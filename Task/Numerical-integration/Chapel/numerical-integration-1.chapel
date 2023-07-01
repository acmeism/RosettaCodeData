proc f1(x:real):real {
  return x**3;
}

proc f2(x:real):real {
  return 1/x;
}

proc f3(x:real):real {
  return x;
}

proc leftRectangleIntegration(a: real, b: real, N: int, f): real{
  var h: real = (b - a)/N;
  var sum: real = 0.0;
  var x_n: real;
  for n in 0..N-1 {
    x_n = a + n * h;
    sum = sum + f(x_n);
  }
  return h * sum;
}

proc rightRectangleIntegration(a: real, b: real, N: int, f): real{
  var h: real = (b - a)/N;
  var sum: real = 0.0;
  var x_n: real;
  for n in 0..N-1 {
    x_n = a + (n + 1) * h;
    sum = sum + f(x_n);
  }
  return h * sum;
}

proc midpointRectangleIntegration(a: real, b: real, N: int, f): real{
  var h: real = (b - a)/N;
  var sum: real = 0.0;
  var x_n: real;
  for n in 0..N-1 {
    x_n = a + (n + 0.5) * h;
    sum = sum + f(x_n);
  }
  return h * sum;
}

proc trapezoidIntegration(a: real(64), b: real(64), N: int(64), f): real{
  var h: real(64) = (b - a)/N;
  var sum: real(64) = f(a) + f(b);
  var x_n: real(64);
  for n in 1..N-1 {
    x_n = a + n * h;
    sum = sum + 2.0 * f(x_n);
  }
  return (h/2.0) * sum;
}

proc simpsonsIntegration(a: real(64), b: real(64), N: int(64), f): real{
  var h: real(64) = (b - a)/N;
  var sum: real(64) = f(a) + f(b);
  var x_n: real(64);
  for n in 1..N-1 by 2 {
    x_n = a + n * h;
    sum = sum + 4.0 * f(x_n);
  }
  for n in 2..N-2 by 2 {
    x_n = a + n * h;
    sum = sum + 2.0 * f(x_n);
  }
  return (h/3.0) * sum;
}

var exact:real;
var calculated:real;

writeln("f(x) = x**3 with 100 steps from 0 to 1");
exact = 0.25;
calculated = leftRectangleIntegration(a = 0.0, b = 1.0, N = 100, f = f1);
writeln("leftRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = rightRectangleIntegration(a = 0.0, b = 1.0, N = 100, f = f1);
writeln("rightRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = midpointRectangleIntegration(a = 0.0, b = 1.0, N = 100, f = f1);
writeln("midpointRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = trapezoidIntegration(a = 0.0, b = 1.0, N = 100, f = f1);
writeln("trapezoidIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = simpsonsIntegration(a = 0.0, b = 1.0, N = 100, f = f1);
writeln("simpsonsIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
writeln();

writeln("f(x) = 1/x with 1000 steps from 1 to 100");
exact = 4.605170;
calculated = leftRectangleIntegration(a = 1.0, b = 100.0, N = 1000, f = f2);
writeln("leftRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = rightRectangleIntegration(a = 1.0, b = 100.0, N = 1000, f = f2);
writeln("rightRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = midpointRectangleIntegration(a = 1.0, b = 100.0, N = 1000, f = f2);
writeln("midpointRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = trapezoidIntegration(a = 1.0, b = 100.0, N = 1000, f = f2);
writeln("trapezoidIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = simpsonsIntegration(a = 1.0, b = 100.0, N = 1000, f = f2);
writeln("simpsonsIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
writeln();

writeln("f(x) = x with 5000000 steps from 0 to 5000");
exact = 12500000;
calculated = leftRectangleIntegration(a = 0.0, b = 5000.0, N = 5000000, f = f3);
writeln("leftRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = rightRectangleIntegration(a = 0.0, b = 5000.0, N = 5000000, f = f3);
writeln("rightRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = midpointRectangleIntegration(a = 0.0, b = 5000.0, N = 5000000, f = f3);
writeln("midpointRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = trapezoidIntegration(a = 0.0, b = 5000.0, N = 5000000, f = f3);
writeln("trapezoidIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = simpsonsIntegration(a = 0.0, b = 5000.0, N = 5000000, f = f3);
writeln("simpsonsIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
writeln();

writeln("f(x) = x with 6000000 steps from 0 to 6000");
exact = 18000000;
calculated = leftRectangleIntegration(a = 0.0, b = 6000.0, N = 6000000, f = f3);
writeln("leftRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = rightRectangleIntegration(a = 0.0, b = 6000.0, N = 6000000, f = f3);
writeln("rightRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = midpointRectangleIntegration(a = 0.0, b = 6000.0, N = 6000000, f = f3);
writeln("midpointRectangleIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = trapezoidIntegration(a = 0.0, b = 6000.0, N = 6000000, f = f3);
writeln("trapezoidIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
calculated = simpsonsIntegration(a = 0.0, b = 6000.0, N = 6000000, f = f3);
writeln("simpsonsIntegration: calculated = ", calculated, "; exact = ", exact, "; difference = ", abs(calculated - exact));
writeln();
