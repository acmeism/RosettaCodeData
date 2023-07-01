#define PI 3.141592653589793
#define TWO_PI 6.283185307179586

double normalize2deg(double a) {
  while (a < 0) a += 360;
  while (a >= 360) a -= 360;
  return a;
}
double normalize2grad(double a) {
  while (a < 0) a += 400;
  while (a >= 400) a -= 400;
  return a;
}
double normalize2mil(double a) {
  while (a < 0) a += 6400;
  while (a >= 6400) a -= 6400;
  return a;
}
double normalize2rad(double a) {
  while (a < 0) a += TWO_PI;
  while (a >= TWO_PI) a -= TWO_PI;
  return a;
}

double deg2grad(double a) {return a * 10 / 9;}
double deg2mil(double a) {return a * 160 / 9;}
double deg2rad(double a) {return a * PI / 180;}

double grad2deg(double a) {return a * 9 / 10;}
double grad2mil(double a) {return a * 16;}
double grad2rad(double a) {return a * PI / 200;}

double mil2deg(double a) {return a * 9 / 160;}
double mil2grad(double a) {return a / 16;}
double mil2rad(double a) {return a * PI / 3200;}

double rad2deg(double a) {return a * 180 / PI;}
double rad2grad(double a) {return a * 200 / PI;}
double rad2mil(double a) {return a * 3200 / PI;}
