use List::Utils;

sub beadsort(@l) {
    (transpose(transpose(map {[1 xx $_]}, @l))).map(*.elems);
}

my @list = 2,1,3,5;
say beadsort(@list).perl;
