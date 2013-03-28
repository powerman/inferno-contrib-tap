implement TAP;

include "sys.m";
	sys: Sys;
	sprint: import sys;
include "draw.m";
include "string.m";
	str: String;
include "bufio.m";
	bufio: Bufio;
	Iobuf: import bufio;
include "debug.m";
        debug: Debug;
        Prog, Module, Exp: import debug;
include "../../module/tap.m";

have_plan, tests_run: int;
dir, reason: string;
ex: string;
stopwatch: int;

init()
{
	sys = load Sys Sys->PATH;
	str = load String String->PATH;
	if(str == nil)
		bail_out(sprint("load String %s: %r", String->PATH));
        debug = load Debug Debug->PATH;
	if(debug == nil)
		bail_out(sprint("load Debug %s: %r", Debug->PATH));
	debug->init();
	bufio = load Bufio Bufio->PATH;
	if(bufio == nil)
		bail_out(sprint("load Bufio %s: %r", Bufio->PATH));
}

plan(tests: int)
{
	have_plan = 1;
	out_plan(tests);
}

done()
{
	if(!have_plan)
		out_plan(tests_run);
}

skip_all(reason: string)
{
	out_skipall(reason);
	exit;
}

bail_out(reason: string)
{
	out_bailout(reason);
	exit;
}

skip(howmany: int, msg: string)
{
	for(i := 0; i < howmany; i++){
		(tmpdir, tmpreason) := (dir, reason);
		(dir, reason) = ("SKIP", msg);
		out_ok(nil);
		(dir, reason) = (tmpdir, tmpreason);
	}
	raise "SKIP";
}

todo(msg: string)
{
	if(msg == nil)
		(dir, reason) = (nil, nil);
	else
		(dir, reason) = ("TODO", msg);
}

diag(msg: string)
{
	out_diag(msg);
}

ok(bool:int, msg: string)
{
	if(bool)
		return out_ok(msg);
	return out_not_ok(msg);
}

eq(a,b: string, msg: string)
{
	if(msg == nil)
		msg = "eq: " + quotemsg(b);
	if(a == b)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("       got: %#q", a));
	out_failed(sprint("  expected: %#q", b));
}

ne(a,b: string, msg: string)
{
	if(msg == nil)
		msg = "ne: " + quotemsg(b);
	if(a != b)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("  %#q", a));
	out_failed("      ne");
	out_failed(sprint("  %#q", b));
}

eq_int(a,b: int, msg: string)
{
	if(msg == nil)
		msg = "eq_int: " + string b;
	if(a == b)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("       got: %d", a));
	out_failed(sprint("  expected: %d", b));
}

ne_int(a,b: int, msg: string)
{
	if(msg == nil)
		msg = "ne_int: " + string b;
	if(a != b)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("  %d", a));
	out_failed("      ne");
	out_failed(sprint("  %d", b));
}

eq_real(a,b: real, msg: string)
{
	if(msg == nil)
		msg = "eq_real: " + string b;
	if(a == b)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("       got: %f", a));
	out_failed(sprint("  expected: %f", b));
}

ne_real(a,b: real, msg: string)
{
	if(msg == nil)
		msg = "ne_real: " + string b;
	if(a != b)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("  %f", a));
	out_failed("      ne");
	out_failed(sprint("  %f", b));
}

eq_list[T](cmp: ref fn(a,b: T): int, a,b: list of T, msg: string)
{
	a = sort(cmp, a);
	b = sort(cmp, b);
	for(; a != nil; (a, b) = (tl a, tl b)){
		if(b == nil)
			return out_not_ok(msg);
		if(cmp(hd a, hd b) != 0)
			return out_not_ok(msg);
	}
	if(b != nil)
		return out_not_ok(msg);
	return out_ok(msg);
}

eq_arr[T](cmp: ref fn(a,b: T): int, a,b: array of T, msg: string)
{
	if(len a != len b)
		return out_not_ok(msg);
	inssort(cmp, a);
	inssort(cmp, b);
	for(i := 0; i < len a; i++)
		if(cmp(a[i], b[i]) != 0)
			return out_not_ok(msg);
	return out_ok(msg);
}

catched(e: string)
{
	ex = e;
}

raised(e: string, msg: string)
{
	if(msg == nil)
		msg = "raised: " + quotemsg(e);
	if(len e > 0 && e[len e - 1] == '*')
		if(str->prefix(e[:len e - 1], ex))
			ok(1, msg);
		else
			eq(ex, e, msg);
	else
		eq(ex, e, msg);
	ex = nil;
}

stopwatch_start()
{
	stopwatch = sys->millisec();
}

stopwatch_min(min: int, msg: string)
{
	if(msg == nil)
		msg = "stopwatch >= " + string min;
	n := sys->millisec() - stopwatch;
	stopwatch_start();
	if(n >= min)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("       got: %d", n));
	out_failed(sprint("  expected: >= %d", min));
}

stopwatch_max(max: int, msg: string)
{
	if(msg == nil)
		msg = "stopwatch <= " + string max;
	n := sys->millisec() - stopwatch;
	stopwatch_start();
	if(n <= max)
		return out_ok(msg);
	out_not_ok(msg);
	out_failed(sprint("       got: %d", n));
	out_failed(sprint("  expected: <= %d", max));
}

getmem(): UsedMem
{
	mem := bufio->open("/dev/memory", bufio->OREAD);
	main := int mem.gets('\n');
	heap := int mem.gets('\n');
	img  := int mem.gets('\n');
	return (main, heap, img);
}

ok_mem(was: UsedMem)
{
	now := getmem();
	ok(now.t0 == was.t0 && now.t1 == was.t1 && now.t2 == was.t2, "memory not leaking");
	if(now.t0 != was.t0)
		diag(sprint("main leaking: %d -> %d", was.t0, now.t0));
	if(now.t1 != was.t1)
		diag(sprint("heap leaking: %d -> %d", was.t1, now.t1));
	if(now.t2 != was.t2)
		diag(sprint("image leaking: %d -> %d", was.t2, now.t2));
}

### Internal helpers

quotemsg(msg: string): string
{
	s := "";
	for(i := 0; i < len msg; i++) case msg[i] {
	'\n' => s[len s] = '\\';
		s[len s] = 'n';
	* =>	s[len s] = msg[i];
	}
	return str->quoted(s :: nil);
}

l2a[T](l: list of T): array of T # from mjl's util0
{
	a := array[len l] of T;
	i := 0;
	for(; l != nil; l = tl l)
		a[i++] = hd l;
	return a;
}

a2l[T](a: array of T): list of T # from mjl's util0
{
	l: list of T;
	for(i := len a-1; i >= 0; i--)
		l = a[i]::l;
	return l;
}

inssort[T](cmp: ref fn(a, b: T): int, a: array of T) # from mjl's util0
{
	for(i := 1; i < len a; i++) {
		tmp := a[i];
		for(j := i; j > 0 && cmp(a[j-1], tmp) >= 0; j--)
			a[j] = a[j-1];
		a[j] = tmp;
	}
}

sort[T](cmp: ref fn(a, b: T): int, l: list of T): list of T
{
	a := l2a(l);
	inssort(cmp, a);
	return a2l(a);
}

escape(msg: string): string
{
	esc := "";
	for(i := 0; i < len msg; i++)
		case msg[i] {
		'#' =>	esc[len esc] = '\\';
			esc[len esc] = '#';
		'\n' => esc[len esc] = '\n';
			esc[len esc] = '#';
			esc[len esc] = ' ';
		' ' =>	if(len esc < 3 || esc[len esc - 3:] != "\n# ")
				esc[len esc] = ' ';
		* =>	esc[len esc] = msg[i];
		}
	return esc;
}

out_ok(msg: string)
{
	out_test("ok", msg);
}

out_not_ok(msg: string)
{
	out_test("not ok", msg);
	out_failed(sprint("Failed test %#q", escape(msg)));
	out_failed(sprint("in %s", caller()));
}

out_failed(msg: string)
{
	sys->fprint(sys->fildes(2), "#   %s\n", msg);
}

caller(): string
{
	if(debug == nil)
		return "unknown";
	pid := sys->pctl(0, nil);
	spawn getcaller(pid, c := chan of string);
	return <-c;
}

getcaller(pid: int, c: chan of string)
{
	(p, err) := debug->prog(pid);
	if(err != nil){
		c <-= sprint("debug: prog() failed: %s", err);
		exit;
	}
	stk: array of ref Exp;
	(stk, err) = p.stack();
	if(err != nil){
		c <-= sprint("debug: stack() failed: %s", err);
		exit;
	}
STACK:	for(i := 0; i < len stk; i++){
		stk[i].m.stdsym();
		s := stk[i].srcstr();
		for(l := sys->tokenize(s, "/ ").t1; l != nil; l = tl l)
			if(hd l == "tap.dis")
				continue STACK;
		c <-= s;
		exit;
	}
	c <-= "debug: unknown";
}

### Protocol

out_plan(tests: int)
{
	sys->print("1..%d\n", tests);
}

out_skipall(msg: string)
{
	sys->print("1..0 # SKIP %s\n", escape(msg));
}

out_bailout(msg: string)
{
	sys->print("Bail out! %s\n", escape(msg));
}

out_diag(msg: string)
{
	sys->print("# %s\n", escape(msg));
}

out_test(result, msg: string)
{
	tests_run++;
	if(msg == nil && dir == nil)
		sys->print("%s %d\n", result, tests_run);
	if(msg != nil && dir == nil)
		sys->print("%s %d - %s\n", result, tests_run, escape(msg));
	if(msg == nil && dir != nil)
		sys->print("%s %d # %s %s\n", result, tests_run, dir, escape(reason));
	if(msg != nil && dir != nil)
		sys->print("%s %d - %s # %s %s\n", result, tests_run, escape(msg), dir, escape(reason));
}

