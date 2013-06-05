#include <cstdlib>   // for rand
#include <cmath>     // for atan, sqrt, log, cos
#include <algorithm> // for generate_n

double const pi = 4*std::atan(1.0);

// simple functor for normal distribution
class normal_distribution
{
public:
  normal_distribution(double m, double s): mu(m), sigma(s) {}
  double operator() const // returns a single normally distributed number
  {
    double r1 = (std::rand() + 1.0)/(RAND_MAX + 1.0); // gives equal distribution in (0, 1]
    double r2 = (std::rand() + 1.0)/(RAND_MAX + 1.0);
    return mu + sigma * std::sqrt(-2*std::log(r1))*std::cos(2*pi*r2);
  }
private:
  const double mu, sigma;
};

int main()
{
  double array[1000];
  std::generate_n(array, 1000, normal_distribution(1.0, 0.5));
  return 0;
}
