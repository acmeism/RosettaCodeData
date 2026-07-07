module rosettacode;

import std::io;

fn int gcd(int m, int n)
{
	int temp;
	while (m)
	{
		temp = m;
		m = n % m;
		n = temp;
	}
	return n;
}

fn int lcm(int m, int n)
{
	return m / gcd(m, n) * n;
}

fn int main(String[] args)
{
	io::printfn("lcm(21,35) = %d", lcm(21, 35));
	return 0;
}
