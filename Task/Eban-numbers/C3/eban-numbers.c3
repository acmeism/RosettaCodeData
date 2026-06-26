module rosettacode;

import std::io;

struct Range
{
	long start, end;
	bool print;
}

fn int main(String[] args)
{
	Range[] ranges = {
		{ 2, 1000, true },
		{ 1000, 4000, true },
		{ 2, 10000, false },
		{ 2, 100000, false },
		{ 2, 1000000, false },
		{ 2, 10000000, false },
		{ 2, 100000000, false },
		{ 2, 1000000000, false },
	};

	foreach (Range rg : ranges)
	{
		if (rg.start == 2)
		{
			io::printfn("eban numbers up to and including %d:", rg.end);
		}
		else
		{
			io::printfn("eban numbers between %d and %d (inclusive):", rg.start, rg.end);
		}

		long count;
		for (long i = rg.start; i <= rg.end; i += 2)
		{
			long b = i / 1000000000;
			long r = i % 1000000000;
			long m = r / 1000000;
			r = i % 1000000;
			long t = r / 1000;
			r %= 1000;
			if (m >= 30 && m <= 66)
			{
				m %= 10;
			}
			if (t >= 30 && m <= 66)
			{
				t %= 10;
			}
			if (r >= 30 && r <= 66)
			{
				r %= 10;
			}
			if (b == 0 || b == 2 || b == 4 || b == 6)
			{
				if (m == 0 || m == 2 || m == 4 || m == 6)
				{
					if (t == 0 || t == 2 || t == 4 || t == 6)
					{
						if (r == 0 || r == 2 || r == 4 || r == 6)
						{
							if (rg.print)
							{
								io::printf("%d ", i);
							}
							count++;
						}
					}
				}
			}
		}
		if (rg.print)
		{
			io::printn();
		}
		io::printfn("count = %d\n", count);
	}

	return 0;
}
