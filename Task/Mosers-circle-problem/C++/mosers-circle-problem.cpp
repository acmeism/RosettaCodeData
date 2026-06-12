#include <iostream>
#include <vector>
using namespace std;

// Moser direct
int moser(int n) {
	return (n*n*n*n - 6*n*n*n + 23*n*n - 18*n + 24)/24;
}

// Binomial coefficient nCk
int binomial(int n, int k) {
	if(k < 0 || k > n) return 0;
	int r = 1;
	for(int i=1; i<=k; ++i) r = r * (n - i + 1) / i;
	return r;
}

// Binomial transform
void binomial_transform(const vector<int>& seq, vector<int>& result, int p) {
	for(int n=0; n<p; ++n) {
		int s = 0;
		for(int k=0; k<=n; ++k)
			s += binomial(n,k) * seq[k];
		result[n] = s;
	}
}

// Sum of first 5 of Pascal's triangle
void pascals_triangle(vector<int>& tri, int p) {
	vector<vector<int>> arr(p, vector<int>(p, 0));
	for(int r=0; r<p; ++r) {
		arr[r][0] = 1;
		for(int c=1; c<=r; ++c)
			arr[r][c] = arr[r-1][c-1] + arr[r-1][c];
	}
	for(int r=0; r<p; ++r) {
		tri[r] = 0;
		for(int c=0; c<5; ++c)
			tri[r] += arr[r][c];
	}
}

int main() {
	int p = 20;
	
    cout << "The first 20 values of Moser's circle problem calculated in different ways:\n";
    cout << "Direct calculation of a 4th order equation:\n";
	for(int i=1; i<=p; ++i) cout << moser(i) << " ";
	cout << "\nUsing binomial sums:\n";
	for(int i=1; i<=p; ++i) cout << binomial(i,4) + binomial(i,2) + 1 << " ";
	cout << "\nUsing a binomial transform:\n";
	vector<int> seq(p, 0), bt(p,0);
	for(int i=0; i<5; ++i) seq[i] = 1;
	binomial_transform(seq, bt, p);
	for(int i=0; i<p; ++i) cout << bt[i] << " ";
	cout << "\nPartial sums of Pascals trianle:\n";
	vector<int> tri(p,0);
	pascals_triangle(tri, p);
	for(int i=0; i<p; ++i) cout << tri[i] << " ";
	cout << endl;

	return 0;
}
