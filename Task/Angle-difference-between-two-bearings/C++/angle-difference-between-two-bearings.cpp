#include <cmath>
#include <iostream>
using namespace std;

double getDifference(double b1, double b2) {
	double r = fmod(b2 - b1, 360.0);
	if (r < -180.0)
		r += 360.0;
	if (r >= 180.0)
		r -= 360.0;
	return r;
}

int main()
{
	cout << "Input in -180 to +180 range" << endl;
	cout << getDifference(20.0, 45.0) << endl;
	cout << getDifference(-45.0, 45.0) << endl;
	cout << getDifference(-85.0, 90.0) << endl;
	cout << getDifference(-95.0, 90.0) << endl;
	cout << getDifference(-45.0, 125.0) << endl;
	cout << getDifference(-45.0, 145.0) << endl;
	cout << getDifference(-45.0, 125.0) << endl;
	cout << getDifference(-45.0, 145.0) << endl;
	cout << getDifference(29.4803, -88.6381) << endl;
	cout << getDifference(-78.3251, -159.036) << endl;
	
	cout << "Input in wider range" << endl;
	cout << getDifference(-70099.74233810938, 29840.67437876723) << endl;
	cout << getDifference(-165313.6666297357, 33693.9894517456) << endl;
	cout << getDifference(1174.8380510598456, -154146.66490124757) << endl;
	cout << getDifference(60175.77306795546, 42213.07192354373) << endl;

	return 0;
}
