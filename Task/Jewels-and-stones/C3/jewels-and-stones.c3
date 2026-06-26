module rosettacode;

import std::io;

fn usz count_jewels(String stones, String jewels)
{
	usz count;
	foreach (char c : stones) if (@ok(jewels.index_of_char(c))) count++;
	return count;
}

fn int main(String[] args)
{
	io::printfn("%d", count_jewels("aAAbbbb", "aA"));
	io::printfn("%d", count_jewels("ZZ", "z"));
	return 0;
}
