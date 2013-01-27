module Control.Concurrent.MarkableIORef (
  MarkableIORef,
  newMarkableRef,
  compareAndSet,
  attemptMark,
  readMarkableRefMark,
  readMarkableRef,
  isMarked,
  ) where


import Data.IORef


data MarkedRef a = MarkedRef { ref :: IORef a, mark :: Bool } deriving Eq
type MarkableIORef a = IORef (MarkedRef a)


newMarkableRef :: IORef a -> Bool -> IO (MarkableIORef a)
newMarkableRef ioref marked = do
  newIORef $ MarkedRef { ref = ioref, mark = marked }


casIORef :: Eq a => IORef a -> a -> a -> IO Bool
casIORef ptr old new =
  atomicModifyIORef ptr (\cur -> if cur == old
                                 then (new, True)
                                 else (cur, False))


attemptMark :: MarkableIORef a -> IORef a -> Bool -> IO Bool
attemptMark markableRef expectedRef newMark = atomicModifyIORef markableRef cas
  where
    cas markedRef @ MarkedRef { ref = curRef } =
      if curRef == expectedRef
      then (MarkedRef { ref = curRef, mark = newMark }, True)
      else (markedRef, False)


compareAndSet :: MarkableIORef a -> IORef a -> IORef a -> Bool -> Bool -> IO Bool
compareAndSet markableRef expectedRef newRef expectedMark newMark = do
  curMarkedRef <- readIORef markableRef
  let MarkedRef { ref = curRef, mark = curMark } = curMarkedRef
  if curRef == expectedRef && curMark == expectedMark
    then casIORef markableRef curMarkedRef MarkedRef { ref = newRef, mark = newMark }
    else return False


readMarkableRefMark :: MarkableIORef a -> IO (IORef a, Bool)
readMarkableRefMark markableRef = do
  MarkedRef { ref = curRef, mark = curMark } <- readIORef markableRef
  return (curRef, curMark)


readMarkableRef :: MarkableIORef a -> IO (IORef a)
readMarkableRef = fmap fst . readMarkableRefMark


isMarked :: MarkableIORef a -> IO Bool
isMarked = fmap snd . readMarkableRefMark
