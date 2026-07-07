module rosettacode;

import std::io;

fn int main(String[] args)
{
	for (int i = 1; i <= 100; i++)
	{
		if (i % 15 == 0)
		{
			io::printn("FizzBuzz");
		}
		else if (i % 5 == 0)
		{
			io::printn("Buzz");
		}
		else if (i % 3 == 0)
		{
			io::printn("Fizz");
		}
		else
		{
			io::printn(i);
		}
	}
	return 0;
}
