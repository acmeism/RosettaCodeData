## plotff.gp 11/27/16 aev
## Plotting from any data-file with 2 columns (space delimited), and writing to png-file.
## Especially useful to plot colored fractals using points.
## Note: assign variables: clr, filename and ttl (before using load command).
reset
set terminal png font arial 12 size 640,640
ofn=filename.".png"
set output ofn
unset border; unset xtics; unset ytics; unset key;
set size square
dfn=filename.".dat"
set title ttl font "Arial:Bold,12"
plot dfn using 1:2 with points  pt 7 ps 0.5 lc @clr
set output
