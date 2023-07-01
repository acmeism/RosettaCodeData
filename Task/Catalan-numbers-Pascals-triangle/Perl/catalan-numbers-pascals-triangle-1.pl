use constant N => 15;
my @t = (0, 1);
for(my $i = 1; $i <= N; $i++) {
    for(my $j = $i; $j > 1; $j--) { $t[$j] += $t[$j-1] }
    $t[$i+1] = $t[$i];
    for(my $j = $i+1; $j>1; $j--) { $t[$j] += $t[$j-1] }
    print $t[$i+1] - $t[$i], " ";
}
