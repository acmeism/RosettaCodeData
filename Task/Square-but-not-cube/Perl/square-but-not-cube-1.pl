while ($cnt < 30) {
    $n++;
    $h{$n**2}++;
    $h{$n**3}--;
    $cnt++ if $h{$n**2} > 0;
}

print "First 30 positive integers that are a square but not a cube:\n";
print "$_ " for sort { $a <=> $b } grep { $h{$_} == 1 } keys %h;

print "\n\nFirst 3 positive integers that are both a square and a cube:\n";
print "$_ " for sort { $a <=> $b } grep { $h{$_} == 0 } keys %h;
