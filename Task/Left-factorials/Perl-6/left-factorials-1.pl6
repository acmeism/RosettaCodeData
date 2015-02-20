multi sub postfix:<!> (0) { 1 };
multi sub postfix:<!> ($n) { [*] 1 .. $n };
multi sub prefix:<!> (0) { 0 };
multi sub prefix:<!> ($k) { [+] (^$k).map: { $_! } }

printf "!%d  = %s\n", $_, !$_ for ^11, 20, 30 ... 110;
printf "!%d has %d digits.\n", $_, (!$_).chars for 1000, 2000 ... 10000;
