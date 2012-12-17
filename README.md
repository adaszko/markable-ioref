What is it?
===========

An aggregate of `IORef` and `Bool` that can be modified atomically.  Comes in
handy when something slightly stronger than `atomicModifyIORef` is required.


Status
======

It works.  Probably eligible for some optimisations.


Installation
============

Assuming you have GHC already installed:

    $ runhaskell Setup.hs configure
    $ runhaskell Setup.hs build
    $ runhaskell Setup.hs install


To Do
=====

* Enable -Wall and clean warnings
* Haddock documentation


License
=======

BSD3


References
==========

* Herlihy, Shavit: The Art of Multiprocessor Programming
* [AtomicMarkableReference](http://docs.oracle.com/javase/1.5.0/docs/api/java/util/concurrent/atomic/AtomicMarkableReference.html)
