#!/usr/bin/env sh

for x in `find . -type f -regex .*\.d`; do
    echo $x;

    if [ "`uname`" = "FreeBSD" ]; then
        link="gc-threaded";
    else
        link="gc";
    fi;

    rdmd -debug -gc -gs -I.. -L-l$link $x;
done;
