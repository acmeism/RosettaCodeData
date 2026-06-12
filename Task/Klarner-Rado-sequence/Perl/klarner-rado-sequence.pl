use v5.36;
use List::Util <max min>;

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 2 + length max @V); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

# generate terms up to 'n', as needed
sub Klarner_Rado ($n) {
    state @klarner_rado = 1;
    state @next = ( x2(), x3() );

    return @klarner_rado if +@klarner_rado >= $n; # no additional terms required

    until (@klarner_rado == $n) {
        push @klarner_rado, my $min = min @next;
        $next[0] = x2() if $next[0] == $min;
        $next[1] = x3() if $next[1] == $min;
    }

    sub x2 { state $i = 0; $klarner_rado[$i++] * 2 + 1 }
    sub x3 { state $i = 0; $klarner_rado[$i++] * 3 + 1 }

    @klarner_rado
}

say "First 100 elements of Klarner-Rado sequence:";
say table 10, Klarner_Rado(100);
say 'Terms by powers of 10:';
printf "%10s = %s\n", comma($_), comma( (Klarner_Rado $_)[$_-1] ) for map { 10**$_ } 0..6;
