#include <array>
#include <iostream>

int main()
{
  double x  = 2.0;
  double xi = 0.5;
  double y  = 4.0;
  double yi = 0.25;
  double z  = x + y;
  double zi = 1.0 / ( x + y );

  const std::array values{x, y, z};
  const std::array inverses{xi, yi, zi};

  auto multiplier = [](double a, double b)
  {
    return [=](double m){return a * b * m;};
  };

  for(size_t i = 0; i < values.size(); ++i)
  {
    auto new_function = multiplier(values[i], inverses[i]);
    double value = new_function(i + 1.0);
    std::cout << value << "\n";
  }
}
