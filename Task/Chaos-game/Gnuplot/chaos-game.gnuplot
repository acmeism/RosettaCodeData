## Chaos Game  (Sierpinski triangle) 2/16/17 aev
reset
fn="ChGS3Gnu1"; clr='"red"';
ttl="Chaos Game  (Sierpinski triangle)"
sz=600; sz1=sz/2; sz2=sz1*sqrt(3);
x=y=xf=yf=v=0;
dfn=fn.".dat"; ofn=fn.".png";
set terminal png font arial 12 size 640,640
set print dfn append
set output ofn
unset border; unset xtics; unset ytics; unset key;
set size square
set title ttl font "Arial:Bold,12"
lim=30000; max=100; x=y=xw=yw=p=0;
randgp(top) = floor(rand(0)*top)
x=randgp(sz); y=randgp(sz2);
do for [i=1:lim] {
  v=randgp(3);
  if (v==0) {x=x/2; y=y/2}
  if (v==1) {x=sz1+(sz1-x)/2; y=sz2-(sz2-y)/2}
  if (v==2) {x=sz-(sz-x)/2; y=y/2}
  xf=floor(x); yf=floor(y);
  if(!(xf<1||xf>sz||yf<1||yf>sz)) {print xf," ",yf};
}
plot dfn using 1:2 with points  pt 7 ps 0.5 lc @clr
set output
unset print
