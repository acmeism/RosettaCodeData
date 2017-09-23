## plotdcf.gp 1/11/17 aev
## Plotting a Dragon curve fractal to the png-file.
## Note: assign variables: ord (order), clr (color), filename and ttl (before using load command).
## ord (order)  # a.k.a. level - defines size of fractal (also number of mini-curves).
reset
set style arrow 1 nohead linewidth 1 lc rgb @clr
set term png size 1024,1024
ofn=filename.ord."gp.png"  # Output file name
set output ofn
ttl="Dragon curve fractal: order ".ord
set title ttl font "Arial:Bold,12"
unset border; unset xtics; unset ytics; unset key;
set xrange [0:1.0]; set yrange [0:1.0];
dragon(n, x, y, dx, dy) = n >= ord ?  \
  sprintf("set arrow from %f,%f to %f,%f as 1;", x, y, x + dx, y + dy) : \
  dragon(n + 1, x, y, (dx - dy) / 2, (dy + dx) / 2) . \
  dragon(n + 1, x + dx, y + dy, - (dx + dy) / 2, (dx - dy) / 2);
eval(dragon(0, 0.2, 0.4, 0.7, 0.0))
plot -100
set output
