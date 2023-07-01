## Barnsley fern fractal 2/17/17 aev
reset
fn="BarnsleyFernGnu"; clr='"green"';
ttl="Barnsley fern fractal"
dfn=fn.".dat"; ofn=fn.".png";
set terminal png font arial 12 size 640,640
set print dfn append
set output ofn
unset border; unset xtics; unset ytics; unset key;
set size square
set title ttl font "Arial:Bold,12"
n=100000; max=100; x=y=xw=yw=p=0;
randgp(top) = floor(rand(0)*top)
do for [i=1:n] {
  p=randgp(max);
  if (p==1) {xw=0;yw=0.16*y;}
  if (1<p&&p<=8) {xw=0.2*x-0.26*y;yw=0.23*x+0.22*y+1.6;}
  if (8<p&&p<=15) {xw=-0.15*x+0.28*y;yw=0.26*x+0.24*y+0.44;}
  if (p>15) {xw=0.85*x+0.04*y;yw=-0.04*x+0.85*y+1.6;}
  x=xw;y=yw; print x," ",y;
}
plot dfn using 1:2 with points  pt 7 ps 0.5 lc @clr
set output
unset print
