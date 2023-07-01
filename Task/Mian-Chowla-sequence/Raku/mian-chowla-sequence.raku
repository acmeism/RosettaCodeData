my @mian-chowla = 1, |(2..Inf).map: -> $test {
    state $index = 1;
    state %sums  = 2 => 1;
    my $next;
    my %these;
    @mian-chowla[^$index].map: { ++$next and last if %sums{$_ + $test}:exists; ++%these{$_ + $test} };
    next if $next;
    ++%sums{$test + $test};
    %sums.push: %these;
    ++$index;
    $test
};

put "First 30 terms in the Mian–Chowla sequence:\n", @mian-chowla[^30];
put "\nTerms 91 through 100:\n", @mian-chowla[90..99];
