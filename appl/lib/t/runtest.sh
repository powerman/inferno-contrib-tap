#!/bin/bash -i
TESTDIR=/opt/powerman/tap/appl/lib/t/
DIS=$(basename $0 .t).dis
emu-g sh -c "run /lib/sh/profile; $TESTDIR$DIS; shutdown -h" || :
