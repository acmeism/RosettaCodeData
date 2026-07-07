module rosettacode;

import std::io;

fn void bitwise(int a, int b)
{
	io::printfn("a and b: %d", a & b);
	io::printfn("a or b: %d", a | b);
	io::printfn("a xor b: %d", a ^ b);
	io::printfn("not a: %d", ~a);
	io::printfn("a << n: %d", a << b);
	io::printfn("a >> n: %d", a >> b);
	uint c = (uint)a;
	io::printfn("c >> b: %d", c >> b);
}

fn uint rotr(uint x, uint s)
{
	return (x >> s) | (x << (32 - s));
}

fn int main(String[] args)
{
	int a = 0b1111_1111; // bit literal 255
	int b = 0b0000_0010; // bit literal 2
	bitwise(a, b);
	return 0;
}
