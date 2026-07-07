module rosettacode;

import std::io;

fn int levenshtein(String s, int ls, String t, int lt)
{
	int a, b, c;
	if (!ls) return lt;
	if (!lt) return ls;

	if (s[ls - 1] == t[lt - 1]) return levenshtein(s, ls - 1, t, lt - 1);

	a = levenshtein(s, ls - 1, t, lt - 1);
	b = levenshtein(s, ls, t, lt - 1);
	c = levenshtein(s, ls - 1, t, lt);

	if (a > b) a = b;
	if (a > c) a = c;

	return a + 1;
}

fn int main(String[] args)
{
	String s1 = "rosettacode";
	String s2 = "raisethysword";
	io::printfn("distance between `%s' and `%s': %d", s1, s2, levenshtein(s1, s1.len, s2, s2.len));
	return 0;
}
