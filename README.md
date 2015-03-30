[Test Anything Protocol](http://testanything.org/) module for Limbo. This module is TAP Producer.

Using mkfiles and helper script runtest.sh provided by [opt-mkfiles project](http://code.google.com/p/inferno-opt-mkfiles/) you can run `mk test` both in host OS and Inferno. While there no available TAP consumer for Inferno yet, if you run tests in host OS you can use existing consumer like `prove` command from perl module [Test::Harness](http://search.cpan.org/~andya/Test-Harness/):

```
 powerman@home ~/inferno/opt/powerman/tap/appl/lib $ prove -r
./t/smoke.t .. ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.01 cusr  0.00 csys =  0.03 CPU)
Result: PASS
```

Dependencies:
  * http://code.google.com/p/inferno-opt-mkfiles/


---


To install system-wide (if your Inferno installed in your home directory or if you root):

```
# mkdir -p $INFERNO_ROOT/opt/powerman/
# hg clone https://inferno-contrib-tap.googlecode.com/hg/ $INFERNO_ROOT/opt/powerman/tap
```

To install locally for some project:

```
$ cd $YOUR_PROJECT_DIR
$ mkdir -p opt/powerman/
$ hg clone https://inferno-contrib-tap.googlecode.com/hg/ opt/powerman/tap
$ emu
; cd $YOUR_PROJECT_DIR_INSIDE_EMU
; bind opt /opt
```

Using it in your application (this will allow you to compile your application using both host OS and native limbo without additional options if it was installed locally, but if you installed this module system-wide, you'll need to use `-I$INFERNO_ROOT` for host OS limbo and `-I/` for native limbo):


---


Example:

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