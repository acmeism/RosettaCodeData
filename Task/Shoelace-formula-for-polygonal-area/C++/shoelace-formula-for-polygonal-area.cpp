#include <iostream>
#include <tuple>
#include <vector>

using namespace std;

double shoelace(vector<pair<double, double>> points) {
	double leftSum = 0.0;
	double rightSum = 0.0;

	for (int i = 0; i < points.size(); ++i) {
		int j = (i + 1) % points.size();
		leftSum  += points[i].first * points[j].second;
		rightSum += points[j].first * points[i].second;
	}

	return 0.5 * abs(leftSum - rightSum);
}

void main() {
	vector<pair<double, double>> points = {
		make_pair( 3,  4),
		make_pair( 5, 11),
		make_pair(12,  8),
		make_pair( 9,  5),
		make_pair( 5,  6),
	};

	auto ans = shoelace(points);
	cout << ans << endl;
}
