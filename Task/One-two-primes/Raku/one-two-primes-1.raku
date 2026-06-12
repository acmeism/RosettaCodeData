sub condense ($n) { my $i = $n.index(2); $i ?? "(1 x $i) {$n.substr($i)}" !! $n }

sub onetwo ($d, $s='') { take $s and return unless $d; onetwo($d-1,$s~$_) for 1,2 }

sub get-onetwo ($d) { (gather onetwo $d).hyper.grep(&is-prime)[0] }

printf "%4d: %s\n", $_, get-onetwo($_) for 1..20;
printf "%4d: %s\n", $_, condense get-onetwo($_) for (1..20) »×» 100;
