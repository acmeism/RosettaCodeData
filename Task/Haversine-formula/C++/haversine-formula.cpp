#define _USE_MATH_DEFINES

#include <math.h>
#include <iostream>

const static double EarthRadiusKm = 6372.8;

inline double DegreeToRadian(double angle)
{
	return M_PI * angle / 180.0;
}

class Coordinate
{
public:
	Coordinate(double latitude ,double longitude):myLatitude(latitude), myLongitude(longitude)
	{}

	double Latitude() const
	{
		return myLatitude;
	}

	double Longitude() const
	{
		return myLongitude;
	}

private:

	double myLatitude;
	double myLongitude;
};

double HaversineDistance(const Coordinate& p1, const Coordinate& p2)
{
	double latRad1 = DegreeToRadian(p1.Latitude());
	double latRad2 = DegreeToRadian(p2.Latitude());
	double lonRad1 = DegreeToRadian(p1.Longitude());
	double lonRad2 = DegreeToRadian(p2.Longitude());

	double diffLa = latRad2 - latRad1;
	double doffLo = lonRad2 - lonRad1;

	double computation = asin(sqrt(sin(diffLa / 2) * sin(diffLa / 2) + cos(latRad1) * cos(latRad2) * sin(doffLo / 2) * sin(doffLo / 2)));
	return 2 * EarthRadiusKm * computation;
}

int main()
{
	Coordinate c1(36.12, -86.67);
	Coordinate c2(33.94, -118.4);

	std::cout << "Distance = " << HaversineDistance(c1, c2) << std::endl;
	return 0;
}
