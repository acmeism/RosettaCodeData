module rosettacode;

import std::io;

fn int main(String[] args)
{
	double[<3>] a = { 1.0, 3.0, -5.0 };
	double[<3>] b = { 4.0, -2.0, -1.0 };
	io::printn(a.dot(b));
	return 0;
}
