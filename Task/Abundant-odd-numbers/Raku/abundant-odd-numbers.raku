sub odd-abundant (\x) {
    my @l = x.is-prime ?? 1 !! flat
    1, (3 .. x.sqrt.floor).map: -> \d {
         next unless d +& 1;
         my \y = x div d;
         next if y * d !== x;
         d !== y ?? (d, y) !! d
    };
    @l.sum > x ?? @l.sort !! Empty;
}

sub odd-abundants (Int :$start-at is copy) {
    $start-at = ( $start-at + 2 ) div 3;
    $start-at += $start-at %% 2;
    $start-at *= 3;
    ($start-at, *+6 ... *).hyper.map: {
        next unless my $oa = cache .&odd-abundant;
        sprintf "%6d: divisor sum: {$oa.join: ' + '} = {$oa.sum}", $_
    }
}

put 'First 25 abundant odd numbers:';
.put for odd-abundants( :start-at(1) )[^25];

put "\nOne thousandth abundant odd number:\n" ~ odd-abundants( :start-at(1) )[999] ~

"\n\nFirst abundant odd number above one billion:\n" ~ odd-abundants( :start-at(1_000_000_000) ).head;
