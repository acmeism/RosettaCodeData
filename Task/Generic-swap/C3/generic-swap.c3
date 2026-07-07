module rosettacode;

import std::io;

fn int main(String[] args)
{
  // @swap is a generic macro defined in the stdlib:
  // https://github.com/c3lang/c3c/blob/master/lib/std/core/builtin.c3#L65
	int a = 5;
	int b = 10;
	io::printfn("a = %d, b = %d", a, b);
	@swap(a, b);
	io::printfn("a = %d, b = %d", a, b);
	return 0;
}
