import 'dart:math' as Math;

num RungeKutta4(Function f, num t, num y, num dt){
  num k1 = dt * f(t,y);
  num k2 = dt * f(t+0.5*dt, y + 0.5*k1);
  num k3 = dt * f(t+0.5*dt, y + 0.5*k2);
  num k4 = dt * f(t + dt, y + k3);
  return y + (1/6) * (k1 + 2*k2 + 2*k3 + k4);
}

void main(){
  num t  = 0;
  num dt = 0.1;
  num tf = 10;
  num totalPoints = ((tf-t)/dt).floor()+1;
  num y  = 1;
  Function f  = (num t, num y) => t * Math.sqrt(y);
  Function actual = (num t) => (1/16) * (t*t+4)*(t*t+4);
  for (num i = 0; i <= totalPoints; i++){
    num relativeError = (actual(t) - y)/actual(t);
    if (i%10 == 0){
      print('y(${t.round().toStringAsPrecision(3)}) = ${y.toStringAsPrecision(11)}  Error = ${relativeError.toStringAsPrecision(11)}');
    }
    y  = RungeKutta4(f, t, y, dt);
    t += dt;
  }
}
