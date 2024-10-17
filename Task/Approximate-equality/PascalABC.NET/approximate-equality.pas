function ApproxEqual(x,y,eps: real): boolean := Abs(x - y) < eps;

begin
  var eps := 1e-18;
  ApproxEqual(100000000000000.01, 100000000000000.011,eps).Println;
  ApproxEqual(100.01, 100.011,eps).Println;
  ApproxEqual(10000000000000.001 / 10000.0, 1000000000.0000001000,eps).Println;
  ApproxEqual(0.001, 0.0010000001,eps).Println;
  ApproxEqual(0.000000000000000000000101, 0.0,eps).Println;
  ApproxEqual(Sqrt(2) * Sqrt(2), 2.0,eps).Println;
  ApproxEqual(-Sqrt(2) * Sqrt(2), -2.0,eps).Println;
  ApproxEqual(3.14159265358979323846, 3.14159265358979324,eps).Println  ;
end.
