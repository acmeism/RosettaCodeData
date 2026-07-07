module rosettacode;

import std::io;

fn int main(String[] args)
{
	io::printn("Enter two integers on separate lines:");
	int a = string::to_integer{int}(io::readline(tmem))!!;
	int b = string::to_integer{int}(io::readline(tmem))!!;
	io::printfn("%d\n", a + b);
	return 0;
}
