## Ring of random points 2/18/17 aev
reset
fn="RingRandPntsGnu";
ttl="Ring of random points"
ofn=fn.".png"; lim=1000;
randgp(top) = floor(rand(0)*top)
set terminal png font arial 12 size 640,640
set output ofn
set title ttl font "Arial:Bold,12"
unset key;
set size square
set parametric
set xrange [-20:20]; set yrange [-20:20];
set style line 1 lt rgb "red"
$rring << EOD
EOD
set print $rring append
do for [i=1:lim] {
  x=randgp(30); y=randgp(30);
  r=sqrt(x**2+y**2);
  if (r>=10&&r<=15) \
    {print x," ",y; print -x," ",-y;print x," ",-y; print -x," ",y;}
}
plot [0:2*pi] sin(t)*10,cos(t)*10, sin(t)*15,cos(t)*15 ls 1,\
$rring using 1:2 with points  pt 7 ps 0.5 lc "black"
set output
unset print
