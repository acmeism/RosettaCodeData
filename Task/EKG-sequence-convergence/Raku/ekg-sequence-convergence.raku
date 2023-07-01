sub infix:<shares-divisors-with> { ($^a gcd $^b) > 1 }

sub next-EKG ( *@s ) {
    return first {
        @s ∌ $_  and  @s.tail shares-divisors-with $_
    }, 2..*;
}

sub EKG ( Int $start ) {  1, $start, &next-EKG … *  }

sub converge-at ( @ints ) {
    my @ekgs = @ints.map: &EKG;

    return (2 .. *).first: -> $i {
        [==]  @ekgs.map(     *.[$i]     ) and
        [===] @ekgs.map( *.head($i).Set )
    }
}

say "EKG($_): ", .&EKG.head(10) for 2, 5, 7, 9, 10;

for [5, 7], [2, 5, 7, 9, 10] -> @ints {
    say "EKGs of (@ints[]) converge at term {$_+1}" with converge-at(@ints);
}
