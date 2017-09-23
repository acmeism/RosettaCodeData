## plotscf.gp 12/7/16 aev
## Plotting a Sierpinski carpet fractal to the png-file.
## Note: assign variables: ord (order), clr (color), filename and ttl (before using load command).
## ord (order)  # a.k.a. level - defines size of fractal (also number of dots).
reset
set terminal png font arial 12 size 640,640
ofn=filename.".png"
set output ofn
unset border; unset xtics; unset ytics; unset key;
set title ttl font "Arial:Bold,12"
set xrange [0:1]; set yrange [0:1];
sc(n, x, y, d) = n >= ord ?  \
  sprintf('set object rect from %f,%f to %f,%f fc rgb @clr fs solid;', x, y, x+d, y+d) : \
  sc(n+1, x, y, d/3) . sc(n+1, x+d/3, y, d/3) . \
  sc(n+1, x+2*d/3, y, d/3) . sc(n+1, x, y+d/3, d/3) . \
  sc(n+1, x+2*d/3, y+d/3, d/3) . sc(n+1, x, y+2*d/3, d/3) . \
  sc(n+1, x+d/3, y+2*d/3, d/3) . sc(n+1, x+2*d/3, y+2*d /3, d/3);
eval(sc(0, 0.0, 0.0, 1.0))
plot -100
set output
