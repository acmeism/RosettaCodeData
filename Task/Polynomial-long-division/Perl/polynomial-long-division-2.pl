sub poly_print
{
    my @c = @_;
    my $l = scalar(@c);
    for(my $i=0; $i < $l; $i++) {
	print $c[$i];
	print "x^" . ($l-$i-1) . " + " if ($i < ($l-1));
    }
    print "\n";
}
