libgc binding for D
===================

libgc-d is a binding to the libgc garbage collection
library (also known as the Boehm-Demers-Weiser GC).
This library is primarily useful in the D world for
programming language implementations and virtual
machines, as D has a built-in GC.

Building
--------

You build libgc-d by using Waf:

    $ waf configure --lp64=true --mode=release
    $ waf build
    $ waf install

You can of course adjust the parameters to configure
as needed.
