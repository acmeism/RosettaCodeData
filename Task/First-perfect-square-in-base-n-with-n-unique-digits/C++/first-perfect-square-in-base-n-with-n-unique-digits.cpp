#include <string>
#include <iostream>
#include <cstdlib>
#include <math.h>
#include <chrono>
#include <iomanip>

using namespace std;

const int maxBase = 16;  // maximum base tabulated
int base, bmo, tc; // globals: base, base minus one, test count
const string chars = "0123456789ABCDEF"; // characters to use for the different bases
unsigned long long full; // for allIn() testing

// converts base 10 to string representation of the current base
string toStr(const unsigned long long ull) {
	unsigned long long u = ull; string res = ""; while (u > 0) {
		lldiv_t result1 = lldiv(u, base); res = chars[(int)result1.rem] + res;
		u = (unsigned long long)result1.quot;
	} return res;
}

// converts string to base 10
unsigned long long to10(string s) {
	unsigned long long res = 0; for (char i : s) res = res * base + chars.find(i); return res;
}

// determines whether all characters are present
bool allIn(const unsigned long long ull) {
	unsigned long long u, found; u = ull; found = 0; while (u > 0) {
		lldiv_t result1 = lldiv(u, base); found |= (unsigned long long)1 << result1.rem;
		u = result1.quot;
	} return found == full;
}

// returns the minimum value string, optionally inserting extra digit
string fixup(int n) {
	string res = chars.substr(0, base); if (n > 0) res = res.insert(n, chars.substr(n, 1));
	return "10" + res.substr(2);
}

// perform the calculations for one base
void doOne() {
	bmo = base - 1; tc = 0; unsigned long long sq, rt, dn, d;
	int id = 0, dr = (base & 1) == 1 ? base >> 1 : 0, inc = 1, sdr[maxBase] = { 0 };
	full = ((unsigned long long)1 << base) - 1;
	int rc = 0; for (int i = 0; i < bmo; i++) {
		sdr[i] = (i * i) % bmo; if (sdr[i] == dr) rc++; if (sdr[i] == 0) sdr[i] += bmo;
	}
	if (dr > 0) {
		id = base; for (int i = 1; i <= dr; i++)
			if (sdr[i] >= dr) if (id > sdr[i]) id = sdr[i]; id -= dr;
	}
	sq = to10(fixup(id)); rt = (unsigned long long)sqrt(sq) + 1; sq = rt * rt;
	dn = (rt << 1) + 1; d = 1; if (base > 3 && rc > 0) {
		while (sq % bmo != dr) { rt += 1; sq += dn; dn += 2; } // alligns sq to dr
		inc = bmo / rc; if (inc > 1) { dn += rt * (inc - 2) - 1; d = inc * inc; }
		dn += dn + d;
	} d <<= 1;
	do { if (allIn(sq)) break; sq += dn; dn += d; tc++; } while (true);
	rt += tc * inc;
	cout << setw(4) << base << setw(3) << inc << "  " << setw(2)
		<< (id > 0 ? chars.substr(id, 1) : " ") << setw(10) << toStr(rt) << "  "
		<< setw(20) << left << toStr(sq) << right << setw(12) << tc << endl;
}

int main() {
	cout << "base inc id      root  sqr                   test count" << endl;
	auto st = chrono::system_clock::now();
	for (base = 2; base <= maxBase; base++) doOne();
	chrono::duration<double> et = chrono::system_clock::now() - st;
	cout << "\nComputation time was " << et.count() * 1000 << " milliseconds" << endl;
	return 0;
}
