## plotpoly.gp 1/10/17 aev
## Plotting a polyspiral and writing to the png-file.
## Note: assign variables: rng, d, clr, filename and ttl (before using load command).
## Direction d (-1 clockwise / 1 counter-clockwise)
reset
set terminal png font arial 12 size 640,640
ofn=filename.".png"
set output ofn
unset border; unset xtics; unset ytics; unset key;
set title ttl font "Arial:Bold,12"
set parametric
c=rng*pi; set xrange[-c:c]; set yrange[-c:c];
set dummy t
plot [0:c] t*cos(d*t), t*sin(d*t) lt rgb @clr
set output
