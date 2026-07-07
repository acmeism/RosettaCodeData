module rosettacode;

import std::io;

fn void analyze(String s)
{
	io::printfn("Examining [%s] which has length of %d:", s, s.len);
	if (s.len > 1)
	{
		char b = s[0];
		foreach (i, c : s[1..])
		{
			if (c != b)
			{
				io::printn("Not all characters in the string are the same.");
				io::printfn("'%c' (0x%x) is different at position %d", c, c, i);
				return;
			}
		}
	}
	io::printn("All characters in the string are the same.");
}

fn int main(String[] args)
{
	String[] strs = { "", "   ", "2", "333", ".55", "tttTTT", "4444 444k" };
	foreach (str : strs)
	{
		analyze(str);
	}
	return 0;
}
