/*
 * compiled with:
 * g++ (Debian 8.3.0-6) 8.3.0
 *
 * g++ -std=c++14 -o rk4 %
 *
 */
# include <iostream>
# include <math.h>

auto rk4(double f(double, double))
{
  return [f](double t, double y, double dt) -> double {
    double dy1 { dt * f( t     , y       ) },
           dy2 { dt * f( t+dt/2, y+dy1/2 ) },
           dy3 { dt * f( t+dt/2, y+dy2/2 ) },
           dy4 { dt * f( t+dt  , y+dy3   ) };
    return ( dy1 + 2*dy2 + 2*dy3 + dy4 ) / 6;
  };
}

int main(void)
{
  constexpr
    double TIME_MAXIMUM    {  10.0 },
           T_START         {   0.0 },
           Y_START         {   1.0 },
           DT              {   0.1 },
           WHOLE_TOLERANCE { 1e-12 };

  auto dy = rk4( [](double t, double y) -> double { return t*sqrt(y); } ) ;

  for (
      auto y { Y_START }, t { T_START };
      t <= TIME_MAXIMUM;
      y += dy(t,y,DT), t += DT
      )
    if (ceilf(t)-t < WHOLE_TOLERANCE)
      printf("y(%4.1f)\t=%12.6f \t error: %12.6e\n", t, y, std::fabs(y - pow(t*t+4,2)/16));

  return 0;
}
