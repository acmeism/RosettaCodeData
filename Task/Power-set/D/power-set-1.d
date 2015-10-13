import std.algorithm;
import std.range;

auto powerSet(R)(R r)
{
	return
		(1L<<r.length)
		.iota
		.map!(i =>
			r.enumerate
			.filter!(t => (1<<t[0]) & i)
			.map!(t => t[1])
		);
}

unittest
{
	int[] emptyArr;
	assert(emptyArr.powerSet.equal!equal([emptyArr]));
	assert(emptyArr.powerSet.powerSet.equal!(equal!equal)([[], [emptyArr]]));
}

void main(string[] args)
{
	import std.stdio;
	args[1..$].powerSet.each!writeln;
}
