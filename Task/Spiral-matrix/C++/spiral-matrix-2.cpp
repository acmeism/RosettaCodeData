#include <vector>
#include <iostream>
using namespace std;
int main() {
	const int n = 5;
	const int dx[] = {0, 1, 0, -1}, dy[] = {1, 0, -1, 0};
	int x = 0, y = -1, c = 0;
	vector<vector<int>> m(n, vector<int>(n));
	for (int i = 0, im = 0; i < n + n - 1; ++i, im = i % 4)
		for (int j = 0, jlen = (n + n - i) / 2; j < jlen; ++j)
			m[x += dx[im]][y += dy[im]] = ++c;
	for (auto & r : m) {
		for (auto & v : r)
			cout << v << ' ';
		cout << endl;
	}
}
