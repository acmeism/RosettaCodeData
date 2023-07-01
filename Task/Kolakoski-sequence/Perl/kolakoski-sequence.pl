sub kolakoski {
    my($terms,@seed) = @_;
    my @k;
    my $k = $seed[0] == 1 ? 1 : 0;
    if ($k == 1) { @k = (1, split //, (($seed[1]) x $seed[1])) }
    else         { @k = ($seed[0]) x $seed[0] }
    do {
        $k++;
        push @k, ($seed[$k % @seed]) x $k[$k];
    } until $terms <= @k;
    @k[0..$terms-1]
}

sub rle {
    (my $string = join '', @_) =~ s/((.)\2*)/length $1/eg;
    split '', $string
}

for ([20,1,2], [20,2,1], [30,1,3,1,2], [30,1,3,2,1]) {
    $terms = shift @$_;
    print "\n$terms members of the series generated from [@$_] is:\n";
    print join(' ', @kolakoski = kolakoski($terms, @$_)) . "\n";
    $status = join('', @rle = rle(@kolakoski)) eq join('', @kolakoski[0..$#rle]) ? 'True' : 'False';
    print "Looks like a Kolakoski sequence?: $status\n";
}
