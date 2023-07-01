using namespace std;

#include <iostream>
#include <ctime>

#define n 100
#define nn ((n * (n + 1)) >> 1)

bool Contains(int lst[], int item, int size) {
	for (int i = 0; i < size; i++) if (item == lst[i]) return true;
	return false;
}

int * MianChowla()
{
	static int mc[n]; mc[0] = 1;
	int sums[nn];	sums[0] = 2;
	int sum, le, ss = 1;
	for (int i = 1; i < n; i++) {
		le = ss;
		for (int j = mc[i - 1] + 1; ; j++) {
			mc[i] = j;
			for (int k = 0; k <= i; k++) {
				sum = mc[k] + j;
				if (Contains(sums, sum, ss)) {
					ss = le; goto nxtJ;
				}
				sums[ss++] = sum;
			}
			break;
		nxtJ:;
		}
	}
	return mc;
}

int main() {
	clock_t st = clock(); int * mc; mc = MianChowla();
	double et = ((double)(clock() - st)) / CLOCKS_PER_SEC;
	cout << "The first 30 terms of the Mian-Chowla sequence are:\n";
	for (int i = 0; i < 30; i++) { cout << mc[i] << ' '; }
	cout << "\n\nTerms 91 to 100 of the Mian-Chowla sequence are:\n";
	for (int i = 90; i < 100; i++) { cout << mc[i] << ' '; }
	cout << "\n\nComputation time was " << et << " seconds.";
}
