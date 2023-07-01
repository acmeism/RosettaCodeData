use Base::Any;

for < 4 -4 0 -7  10 -2  146 -3  15 -10  -19 -10  107 -16
    227.65625 -16  2.375 -4 -1.3e2 -8 41371457.268272761 -36
    -145115966751439403/3241792 -1184 > -> $v, $r {
    my $nbase = $v.&to-base($r, :precision(-5));
    printf "%21s.&to-base\(%5d\) = %-11s : %13s.&from-base\(%5d\) = %s\n",
      +$v, $r, $nbase, "'$nbase'", $r, $nbase.&from-base($r);
}
