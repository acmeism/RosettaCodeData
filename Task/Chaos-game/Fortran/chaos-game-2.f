set terminal jpeg enhanced size 1600,960
set output 'chaos.jpg'
set nokey
set style line 1 lc rgb '#0060ad' lt 1 lw 3 pt 7 ps 0.3
plot 'aus.csv' using 1:3 with points ls 1 notitle
