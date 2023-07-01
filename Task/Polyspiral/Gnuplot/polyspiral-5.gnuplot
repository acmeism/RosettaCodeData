## Animation for polyspirals PS0 - PS6
reset
set terminal gif animate delay 100 loop 2 size 640,640
set output 'PolySpirsAnim.gif'
unset border; unset xtics; unset ytics; unset key;
unset autoscale
set xrange[0:640]
set yrange[0:640]
do for [i=0:6]{plot 'PS'.i.'.png' binary filetype=png with rgbimage}
set output

## Animation for nice figures PS8 - PS14
reset
set terminal gif animate delay 100 loop 2 size 640,640
set output 'NiceFigsAnim.gif'
unset border; unset xtics; unset ytics; unset key;
unset autoscale
set xrange[0:640]
set yrange[0:640]
do for [i=8:14]{plot 'PS'.i.'.png' binary filetype=png with rgbimage}
set output
