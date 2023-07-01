my $sdacc = SDAccum->new;
my $sd;

foreach my $v ( 2,4,4,4,5,5,7,9 ) {
    $sd = $sdacc->value($v);
}
print "std dev = $sd\n";
