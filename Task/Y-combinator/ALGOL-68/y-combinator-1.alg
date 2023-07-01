BEGIN
  MODE F = PROC(INT)INT;
  MODE Y = PROC(Y)F;

# compare python Y = lambda f: (lambda x: x(x)) (lambda y: f( lambda *args: y(y)(*args)))#
  PROC y =      (PROC(F)F f)F: (  (Y x)F: x(x)) (  (Y z)F: f((INT arg )INT: z(z)( arg )));

  PROC fib = (F f)F: (INT n)INT: CASE n IN n,n OUT f(n-1) + f(n-2) ESAC;

  FOR i TO 10 DO print(y(fib)(i)) OD
END
