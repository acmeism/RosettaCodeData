say   "First 25 Vile numbers:\n", (1..Inf).&vile[^25];
say "\nFirst 25 Dopey numbers:\n", (1..Inf).&dopey[^25];

put "\nupto:  Vile  Dopey";
for ^10 {
    my @r = 1 .. 2 +< $_;
    printf "%4d:   %3d    %3d\n", @r.tail, +vile(@r), +dopey(@r);
}

sub vile (@n)  { @n.grep: *.lsb %% 2 }
sub dopey (@n) { @n.grep: *.lsb % 2 }
