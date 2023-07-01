reset
set terminal pngcairo
set output 'rc-annulus.png'
set xrange [-20:20]
set yrange [-20:20]
plot "rc-annulus.dat" with points pt 1
