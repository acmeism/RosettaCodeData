#include <iostream>
#include <vector>
using namespace std;

int doStuff(int a, int b) {
	return a + b;
}

int main() {

	int t;
	cin >> t;

	vector<pair<int, int>> list(t);

	for(int j=0; j<t; j++){
		cin >> list[j].first >> list[j].second;
	}

	cout << endl;

	for(int j=0;j<t;j++){
		cout << doStuff(list[j].first, list[j].second) << endl;;
	}
}
