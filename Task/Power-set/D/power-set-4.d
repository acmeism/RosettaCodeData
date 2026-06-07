void main(string[] args)
{
	import std.stdio;
	args[1..$].powerSet.each!writeln;
}
