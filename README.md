# Description

[Test Anything Protocol](http://testanything.org/) module for Limbo. This
module is TAP Producer.


# Install

Make directory with this module available in /opt/powerman/tap/.

Install system-wide:

```
# git clone https://github.com/powerman/inferno-contrib-tap.git $INFERNO_ROOT/opt/powerman/tap
```

or in your home directory:

```
$ git clone https://github.com/powerman/inferno-contrib-tap.git $INFERNO_USER_HOME/opt/powerman/tap
$ emu
; bind opt /opt
```

or locally for your project:

```
$ git clone https://github.com/powerman/inferno-contrib-tap.git $YOUR_PROJECT_DIR/opt/powerman/tap
$ emu
; cd $YOUR_PROJECT_DIR_INSIDE_EMU
; bind opt /opt
```

If you want to run commands and read man pages without entering full path
to them (like `/opt/VENDOR/APP/dis/cmd/NAME`) you should also install and
use https://github.com/powerman/inferno-opt-setup 

## Dependencies

* https://github.com/powerman/inferno-opt-mkfiles


# Usage

Write tests for your app using this module.

Using mkfiles and helper script runtest.sh provided by
https://github.com/powerman/inferno-opt-mkfiles you can run `mk test`
both in host OS and Inferno. While there no available TAP consumer for
Inferno yet, if you run tests in host OS you can use existing consumer
like [prove](https://metacpan.org/pod/distribution/Test-Harness/bin/prove)
command from Perl module Test::Harness:

```
powerman@home ~/inferno/opt/powerman/tap/appl/lib $ prove -r
./t/smoke.t .. ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.01 cusr  0.00 csys =  0.03 CPU)
Result: PASS
```

## Example

Such include path will let you compile your application using both host OS
and native limbo without additional options if this module was installed
locally in your project, but if you installed this module system-wide,
then you'll need to use `-I$INFERNO_ROOT` for host OS limbo and `-I/` for
native limbo.

```
implement T;

include "opt/powerman/tap/module/t.m";

test()
{
    plan(3);

    ok(1==1,            "true test");
    eq_int(2, 3,        "2 == 3?");
    eq("abc", "def",    "abc == def?");
}
```

This test will produce output:

```
1..3
ok 1 - true test
not ok 2 - 2 == 3?
#   Failed test '2 == 3?'
#   in smoke.b:10.4, 27
#          got: 2
#     expected: 3
not ok 3 - abc == def?
#   Failed test 'abc == def?'
#   in smoke.b:11.4, 35
#          got: 'abc'
#     expected: 'def'
```
