/*
 * compiled with gcc 5.4:
 * g++-mp-5 -std=c++14 -o rk4 rk4.cc
 *
 */
# include <iostream>
# include <math.h>
using namespace std;

auto rk4(double f(double, double))
{
        return
        [       f            ](double t, double y, double dt ) -> double{ return
        [t,y,dt,f            ](                    double dy1) -> double{ return
        [t,y,dt,f,dy1        ](                    double dy2) -> double{ return
        [t,y,dt,f,dy1,dy2    ](                    double dy3) -> double{ return
        [t,y,dt,f,dy1,dy2,dy3](                    double dy4) -> double{ return
        ( dy1 + 2*dy2 + 2*dy3 + dy4 ) / 6   ;} (
        dt * f( t+dt  , y+dy3   )          );} (
        dt * f( t+dt/2, y+dy2/2 )          );} (
        dt * f( t+dt/2, y+dy1/2 )          );} (
        dt * f( t     , y       )          );} ;
}

int main(void)
{
        const double TIME_MAXIMUM = 10.0, WHOLE_TOLERANCE = 1e-12 ;
        const double T_START = 0.0, Y_START = 1.0, DT = 0.10;

        auto eval_diff_eqn = [               ](double t, double y)->double{ return t*sqrt(y)                         ; } ;
        auto eval_solution = [               ](double t          )->double{ return pow(t*t+4,2)/16                   ; } ;
        auto find_error    = [eval_solution  ](double t, double y)->double{ return fabs(y-eval_solution(t))          ; } ;
        auto is_whole      = [WHOLE_TOLERANCE](double t          )->bool  { return fabs(t-round(t)) < WHOLE_TOLERANCE; } ;

        auto dy = rk4( eval_diff_eqn ) ;

        double y = Y_START, t = T_START ;

        while(t <= TIME_MAXIMUM) {
          if (is_whole(t)) { printf("y(%4.1f)\t=%12.6f \t error: %12.6e\n",t,y,find_error(t,y)); }
          y += dy(t,y,DT) ; t += DT;
        }
        return 0;
}
