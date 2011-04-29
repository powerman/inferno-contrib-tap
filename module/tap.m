TAP: module
{
	PATH: con "/opt/powerman/tap/dis/lib/tap.dis";

	UsedMem: type (int, int, int);

	init: fn();

	plan: fn(tests: int); # use either plan() or done()
	skip_all: fn(reason: string); # will exit
	bail_out: fn(reason: string); # will exit
	done: fn(); # use either plan() or done()

	diag: fn(msg: string);

	skip: fn(howmany: int, reason: string); # will raise "SKIP"
	todo: fn(reason: string); # set to nil to switch off TODO

	ok:	fn(bool:int,	msg: string);
	eq_int:	fn(a,b: int,	msg: string);
	ne_int:	fn(a,b: int,	msg: string);
	eq:	fn(a,b: string, msg: string);
	ne:	fn(a,b: string, msg: string);
	eq_list:fn[T](cmp: ref fn(a,b: T): int, a,b: list  of T, msg: string); # will sort a&b
	eq_arr: fn[T](cmp: ref fn(a,b: T): int, a,b: array of T, msg: string); # will sort a&b
	catched:fn(e: string);
	raised: fn(e: string,	msg: string);
	stopwatch_start:fn();
	stopwatch_min:	fn(min: int, msg: string);
	stopwatch_max:	fn(max: int, msg: string);
	getmem: fn(): UsedMem;
	ok_mem: fn(was: UsedMem);
};
