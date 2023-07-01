#include <iostream>
#include <cmath>
#include <cassert>
using namespace std;

/** Calculate determinant of matrix:
	[a b]
	[c d]
*/
inline double Det(double a, double b, double c, double d)
{
	return a*d - b*c;
}

/// Calculate intersection of two lines.
///\return true if found, false if not found or error
bool LineLineIntersect(double x1, double y1, // Line 1 start
	double x2, double y2, // Line 1 end
	double x3, double y3, // Line 2 start
	double x4, double y4, // Line 2 end
	double &ixOut, double &iyOut) // Output
{
	double detL1 = Det(x1, y1, x2, y2);
	double detL2 = Det(x3, y3, x4, y4);
	double x1mx2 = x1 - x2;
	double x3mx4 = x3 - x4;
	double y1my2 = y1 - y2;
	double y3my4 = y3 - y4;

	double denom = Det(x1mx2, y1my2, x3mx4, y3my4);
	if(denom == 0.0) // Lines don't seem to cross
	{
		ixOut = NAN;
		iyOut = NAN;
		return false;
	}

	double xnom = Det(detL1, x1mx2, detL2, x3mx4);
	double ynom = Det(detL1, y1my2, detL2, y3my4);
	ixOut = xnom / denom;	
	iyOut = ynom / denom;
	if(!isfinite(ixOut) || !isfinite(iyOut)) // Probably a numerical issue
		return false;

	return true; //All OK
}

int main()
{
	// **Simple crossing diagonal lines**

	// Line 1
	double x1=4.0, y1=0.0;
	double x2=6.0, y2=10.0;
	
	// Line 2
	double x3=0.0, y3=3.0;
	double x4=10.0, y4=7.0;

	double ix = -1.0, iy = -1.0;
	bool result = LineLineIntersect(x1, y1, x2, y2, x3, y3, x4, y4, ix, iy);
	cout << "result " <<  result << "," << ix << "," << iy << endl;

	double eps = 1e-6;
	assert(result == true);
	assert(fabs(ix - 5.0) < eps);
	assert(fabs(iy - 5.0) < eps);
        return 0;
}
