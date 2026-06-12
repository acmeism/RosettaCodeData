#include <iostream>
#include <map>
#include <tuple>
#include <vector>

using namespace std;

pair<int, int> twoSum(vector<int> numbers, int sum) {
	auto m = map<int, int>();
	for (size_t i = 0; i < numbers.size(); ++i) {
		// see if the complement is stored
		auto key = sum - numbers[i];

		if (m.find(key) != m.end()) {
			return make_pair(m[key], i);
		}
		m[numbers[i]] = i;
	}

	return make_pair(-1, -1);
}

int main() {
	auto numbers = vector<int>{ 0, 2, 11, 19, 90 };
	const int sum = 21;

	auto ts = twoSum(numbers, sum);
	if (ts.first != -1) {
		cout << "{" << ts.first << ", " << ts.second << "}" << endl;
	} else {
		cout << "no result" << endl;
	}

	return 0;
}
