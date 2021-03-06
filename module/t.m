
include "sys.m";
	sys: Sys;
	sprint: import sys;
include "draw.m";
include "opt/powerman/tap/module/tap.m";
	tap: TAP;
	plan,skip_all,bail_out,done: import tap;
	diag: import tap;
	skip,todo: import tap;
	ok,eq,ne,eq_int,ne_int,eq_real,ne_real,eq_list,eq_arr: import tap;
	catched,raised: import tap;
	stopwatch_start,stopwatch_min,stopwatch_max: import tap;
	getmem,ok_mem: import tap;

T: module
{
	init: fn(nil: ref Draw->Context, nil: list of string);
};

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	tap = load TAP TAP->PATH;
	if(tap == nil){
		sys->print("Bail out! load %s: %r\n", TAP->PATH);
		raise "fail:Bail out! load TAP";
	}
	tap->init();
	test();
}

