module rosettacode;

import std::io;

union Data
{
	int i;
	float f;
	char c;
}

fn int main(String[] args)
{
	// Unions are raw like C.
	// If you want tagged unions, use an enum as the tag like we do in C.
	// Tagged unions are also planed.
	Data data;

	data.i = 5;
	io::printfn("Integer i = %d, address of i = %p", data.i, &data.i);

	data.f = 3.14169;
	io::printfn("Float f = %f, address of f = %p", data.f, &data.f);

	data.c = 'C';
	io::printfn("Character c = %c, address of c = %p", data.c, &data.c);

	return 0;
}
