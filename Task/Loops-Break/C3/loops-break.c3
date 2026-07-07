module rosettacode;

import std::io, libc;

fn int main(String[] args)
{
	Time_t t;
	int a, b;
	libc::srand((uint)libc::time(&t));
	for (;;)
	{
		a = libc::rand() % 20;
		io::printfn("%d", a);
		if (a == 10) break;
		b = libc::rand() % 20;
		io::printfn("%d", b);
	}
	return 0;
}
