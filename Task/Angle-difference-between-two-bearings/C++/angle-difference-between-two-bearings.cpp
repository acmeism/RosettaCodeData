#include <cmath>
#include <iostream>
using namespace std;

double getDifference(double b1, double b2)
{
  double r = fmod(b2 - b1, 360.0);
  if (r < -180.0)
    r += 360.0;
  if (r >= 180.0)
    r -= 360.0;
  return r;
}

inline void printRow(double b1, double b2)
{
  cout << getDifference(b1, b2) << endl;
}

int main()
{
  cout << "Input in -180 to +180 range" << endl;
  printRow(20.0, 45.0);
  printRow(-45.0, 45.0);
  printRow(-85.0, 90.0);
  printRow(-95.0, 90.0);
  printRow(-45.0, 125.0);
  printRow(-45.0, 145.0);
  printRow(-45.0, 125.0);
  printRow(-45.0, 145.0);
  printRow(29.4803, -88.6381);
  printRow(-78.3251, -159.036);

  cout << endl << "Input in wider range" << endl;
  printRow(-70099.74233810938, 29840.67437876723);
  printRow(-165313.6666297357, 33693.9894517456);
  printRow(1174.8380510598456, -154146.66490124757);
  printRow(60175.77306795546, 42213.07192354373);

  return 0;
}
