#include <cmath>
#include <iostream>
#include <numbers>

// constants used in the calculations
static const double DegreesPerHour = 15.0;
static const double DegreesPerRadian = 180.0 * std::numbers::inv_pi;

// a structure for the calculation results
struct SundialCalculation
{
  double HourAngle;
  double HourLineAngle;
};

// a class for a sundial at a location
class Sundial
{
  // intermediate values used in the caclulations
  double m_sinLatitude;
  double m_timeZoneCorrection;

public:
  Sundial(double latitude, double longitude, double legalMeridian) noexcept
    : m_sinLatitude(sin(latitude / DegreesPerRadian))
    , m_timeZoneCorrection(legalMeridian - longitude) {}

  SundialCalculation CalculateShadow(double hoursSinceNoon) const noexcept
  {
    double hourAngle = hoursSinceNoon * DegreesPerHour + m_timeZoneCorrection;
    double hourAngleRad = hourAngle / DegreesPerRadian;
    double hlaRad = atan2(m_sinLatitude * sin(hourAngleRad), cos(hourAngleRad));
    double hourLineAngle = hlaRad * DegreesPerRadian;
    return SundialCalculation {hourAngle, hourLineAngle};
  }
};

int main()
{
  double latitude, longitude, legalMeridian;
  std::cout << "Enter latitude:";
  std::cin >> latitude;
  std::cout << "Enter longitude:";
  std::cin >> longitude;
  std::cout << "Enter legal meridian:";
  std::cin >> legalMeridian;

  // create a sundial at the user specified location
  const Sundial sundial(latitude, longitude, legalMeridian);
  for(int hour = -6; hour < 7; ++hour)
  {
    // cacluate the angles
    auto result = sundial.CalculateShadow(hour);

    // print the results
    auto amOrPm = hour < 0 ? "am" : "pm";
    auto hourString = std::to_string(hour < 1 ? 12 + hour : hour);
    std::cout << hourString << amOrPm <<
    " - sun hour angle:" << result.HourAngle <<
    ", dial hour line angle:" << result.HourLineAngle << "\n";
  }
}
