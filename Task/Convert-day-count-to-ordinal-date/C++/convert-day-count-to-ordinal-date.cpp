#include <iostream>
#include <iomanip>
using namespace std;

void day_count_to_ymd(int dc, int &y, int &m, int &d) {
	long z = dc - 60;
	long era, doe, yoa, doy, mp;
	
	if (z >= 0)
		era = z / 146097;
	else
		era = ((z + 1) / 146097) - 1;
	doe = z - era * 146097;
	yoa = (doe - (doe / 1460) + (doe / 36524) - (doe / 146096)) / 365;
	y = yoa + era * 400;
	doy = doe - (365 * yoa + yoa / 4 - yoa / 100);
	mp = (5 * doy + 2) / 153;
	d = doy - (153 * mp + 2) / 5 + 1;
	m = mp + 3 - 12 * (mp / 10);
	y = y + (mp / 10);
}

string fmt(int n, int w) {
	ostringstream oss;
	oss << setw(w) << setfill('0') << n;
	return oss.str();
}

int main() {
	int day_counts[3] = {0, 109573, 146096};
	for (int dc : day_counts) {
		cout << "Daycount: " << dc << "\n";
		for (int j = 0; j <= 5; ++j) {
			int y, m, d;
			day_count_to_ymd(j * 146097 + dc, y, m, d);
			cout << fmt(d, 2) << "/" << fmt(m, 2) << "/" << fmt(y, 4) << "\n";
		}
		cout << "\n";
	}
	return 0;
}
