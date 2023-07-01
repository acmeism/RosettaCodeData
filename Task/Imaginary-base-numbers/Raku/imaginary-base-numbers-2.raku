use Base::Any;

# TESTING
for 0, 2i, 1, 2i, 5, 2i, -13, 2i, 9i, 2i, -3i, 2i, 7.75-7.5i, 2i, .25, 2i, # base 2i tests
    5+5i,  2i, 5+5i,  3i, 5+5i,  4i, 5+5i,  5i, 5+5i,  6i, # same value, positive imaginary bases
    5+5i, -2i, 5+5i, -3i, 5+5i, -4i, 5+5i, -5i, 5+5i, -6i, # same value, negative imaginary bases
    227.65625+10.859375i, 4i, # larger test value
    31433.3487654321-2902.4480452675i, 6i, # heh
    -3544.29+26541.468i, -10i
  -> $v, $r {
    my $ibase = $v.&to-base($r, :precision(-6));
    printf "%33s.&to-base\(%3si\) = %-11s : %13s.&from-base\(%3si\) = %s\n",
    $v, $r.im, $ibase, "'$ibase'", $r.im, $ibase.&from-base($r).round(1e-10).narrow;
}
