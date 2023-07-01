my @fifo=qw(1 2 3 a b c);

mypush @fifo, 44, 55, 66;
mypop @fifo for 1 .. 6+3;
mypop @fifo; #empty now
