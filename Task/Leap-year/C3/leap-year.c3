module rosettacode;

import std::io;

fn bool is_leap_year(uint year)
{
	return !(year & (year % 100 ? 3 : 15));
}

fn int main(String[] args)
{
	uint[] test_cases = { 1900, 1994, 1996, 1997, 2000, 2024, 2025, 2026, 2100 };
	for (uint i = 0; i < test_cases.len; i++)
	{
		uint year = test_cases[i];
		io::printfn("%d is %sa leap year.", year, is_leap_year(year) ? "" : "not ");
	}
	return 0;
}
