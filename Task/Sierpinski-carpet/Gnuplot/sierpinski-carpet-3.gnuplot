## plotscf1.gp 12/7/16 aev
## Plotting a Sierpinski carpet fractal to the png-file.
## Note: assign variables: ord (order, just for title), clr (color), filename and ttl (before using load command).
## In this version order is always 5.
reset
set terminal png font arial 12 size 640,640
ofn=filename.".png"
set output ofn
unset border; unset xtics; unset ytics; unset key;
set title ttl font "Arial:Bold,12"
o=3
sqr(x,y) = abs(x + y) + abs(x - y) - o
f(x) = o*abs(x) - o
c0(x,y) = abs(x + y) + abs(x - y) - 1
c1(x,y) = c0(o*x,f(y)) * c0(f(x),o*y) * c0(f(x),f(y))
c2(x,y) = c1(o*x,f(y)) * c1(f(x),o*y) * c1(f(x),f(y))
c3(x,y) = c2(o*x,f(y)) * c2(f(x),o*y) * c2(f(x),f(y))
c4(x,y) = c3(o*x,f(y)) * c3(f(x),o*y) * c3(f(x),f(y))
sc(x,y) = sqr(x,y)>0 || c0(x,y)*c1(x,y)*c2(x,y)*c3(x,y)*c4(x,y)<0 ? 0:1
set xrange [-1.5:1.5]; set yrange [-1.5:1.5];
set pm3d map;
set palette model RGB defined (0 "white", 1 @clr);
set size ratio -1
smp=640; set samples smp; set isosamples smp;
unset colorbox
splot sc(x,y)
set output
