my @ulams = 1, 2, &next-ulam … *;

sub next-ulam {
    state $i = 1;
    state @sums = 0,1,1;
    my $last = @ulams[$i];
    (^$i).map: { @sums[@ulams[$_] + $last]++ };
    ++$i;
    quietly ($last ^.. *).first: { @sums[$_] == 1 };
}

for 1 .. 4 {
    say "The {10**$_}th Ulam number is: ", @ulams[10**$_ - 1]
}
