(* Approximate y(t) in dy/dt=f(t,y), y(a)=y0, t going from a to b with
   positive step size h. Produce a list of point pairs as output. *)
fun eulerMethod (f, y0, a, b, h) =
    let
      fun loop (t, y, pointPairs) =
          let
            val pointPairs = (t, y) :: pointPairs
          in
            if b <= t then
              rev pointPairs
            else
              loop (t + h, y + (h * f (t, y)), pointPairs)
          end
    in
      loop (a, y0, nil)
    end

(* How to step temperature according to Newton's law of cooling. *)
fun f (t, temp) = ~0.07 * (temp - 20.0)

val data2 = eulerMethod (f, 100.0, 0.0, 100.0, 2.0)
and data5 = eulerMethod (f, 100.0, 0.0, 100.0, 5.0)
and data10 = eulerMethod (f, 100.0, 0.0, 100.0, 10.0)

fun printPointPairs pointPairs =
    app (fn (t, y) => (print (Real.toString t);
                       print " ";
                       print (Real.toString y);
                       print "\n"))
        pointPairs

;

print ("set encoding utf8\n");
print ("set term png size 1000,750 font 'Brioso Pro,16'\n");
print ("set output 'newton-cooling-SML.png'\n");
print ("set grid\n");
print ("set title 'Newton\\U+2019s Law of Cooling'\n");
print ("set xlabel 'Elapsed time (seconds)'\n");
print ("set ylabel 'Temperature (Celsius)'\n");
print ("set xrange [0:100]\n");
print ("set yrange [15:100]\n");
print ("y(x) = 20.0 + (80.0 * exp (-0.07 * x))\n");
print ("plot y(x) with lines title 'Analytic solution', \\\n");
print ("     '-' with linespoints title 'Euler method, step size 2s', \\\n");
print ("     '-' with linespoints title 'Step size 5s', \\\n");
print ("     '-' with linespoints title 'Step size 10s'\n");
printPointPairs data2;
print ("e\n");
printPointPairs data5;
print ("e\n");
printPointPairs data10;
print ("e\n");
