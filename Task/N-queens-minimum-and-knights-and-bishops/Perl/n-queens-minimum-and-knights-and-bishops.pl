use v5.36;
use builtin 'true', 'false';
no warnings 'experimental::for_list', 'experimental::builtin';

my(@B, @D1, @D2, @D1x, @D2x, $N, $Min, $Layout);

sub X ($a,$b)       { my @c; for my $aa (0..$a-1) { for my $bb (0..$b-1) { push @c, $aa, $bb } } @c }
sub Xr($a,$b,$c,$d) { my @c; for my $ab ($a..$b)  { for my $cd ($c..$d)  { push @c, $ab, $cd } } @c }

sub is_attacked($piece, $r, $c) {
    if ($piece eq 'Q') {
        for (0..$N-1) { return true if $B[$_][$c] or $B[$r][$_] }
        return true if $D1x[ $D1[$r][$c] ] or
                       $D2x[ $D2[$r][$c] ]
    } elsif ($piece eq 'B') {
        return true if $D1x[ $D1[$r][$c] ] or $D2x[ $D2[$r][$c] ]
    } else { # 'K'
        return true if (
            $B[$r][$c] or
            $r+2 < $N and $c-1 >= 0 and $B[$r+2][$c-1] or
            $r-2 >= 0 and $c-1 >= 0 and $B[$r-2][$c-1] or
            $r+2 < $N and $c+1 < $N and $B[$r+2][$c+1] or
            $r-2 >= 0 and $c+1 < $N and $B[$r-2][$c+1] or
            $r+1 < $N and $c+2 < $N and $B[$r+1][$c+2] or
            $r-1 >= 0 and $c+2 < $N and $B[$r-1][$c+2] or
            $r+1 < $N and $c-2 >= 0 and $B[$r+1][$c-2] or
            $r-1 >= 0 and $c-2 >= 0 and $B[$r-1][$c-2]
        )
   }
   false
}

sub attacks($piece, $r, $c, $tr, $tc) {
    if    ($piece eq 'Q') { $r==$tr or $c==$tc or abs($r - $tr)==abs($c - $tc) }
    elsif ($piece eq 'B') { abs($r - $tr) == abs($c - $tc) }
    else                  {
        my ($rd, $cd) = (abs($tr - $r), abs($tc - $c));
        ($rd == 1 and $cd == 2) or ($rd == 2 and $cd == 1)
    }
}

sub store_layout($piece) {
    $Layout = '';
    for (@B) {
        map { $Layout .= $_ ?  $piece.' ' : '. ' } @$_;
        $Layout .=  "\n";
    }
}

sub place_piece($piece, $so_far, $max) {
    return if $so_far >= $Min;
    my ($all_attacked,$ti,$tj) = (true,0,0);
    for my($i,$j) (X $N, $N) {
        unless (is_attacked($piece, $i, $j)) {
            ($all_attacked,$ti,$tj) = (false,$i,$j) and last
        }
        last unless $all_attacked
    }
    if ($all_attacked) {
        $Min = $so_far;
        store_layout($piece);
    } elsif ($so_far <= $max) {
        my($si,$sj) = ($ti,$tj);
        if ($piece eq 'K') {
            $si -= 2; $si = 0 if $si < 0;
            $sj -= 2; $sj = 0 if $sj < 0;
        }
        for my ($i,$j) (Xr $si, $N-1, $sj, $N-1) {
            unless (is_attacked($piece, $i, $j)) {
                if (($i == $ti and $j == $tj) or attacks($piece, $i, $j, $ti, $tj)) {
                    $B[$i][$j] = true;
                    unless ($piece eq 'K') {
                        ($D1x[ $D1[$i][$j] ], $D2x[ $D2[$i][$j] ]) = (true,true);
                    };
                    place_piece($piece, $so_far+1, $max);
                    $B[$i][$j] = false;
                    unless ($piece eq 'K') {
                        ($D1x[ $D1[$i][$j] ], $D2x[ $D2[$i][$j] ]) = (false,false);
                    }
                }
            }
         }
     }
}

my @Pieces = <Q B K>;
my %Limits = ( 'Q' =>   10,     'B' =>    10,     'K' =>    10   );
my %Names  = ( 'Q' => 'Queens', 'B' => 'Bishops', 'K' =>'Knights');

for my $piece (@Pieces) {
    say $Names{$piece} . "\n=======\n";
    for ($N = 1 ; ; $N++) {
        @B = map { [ (false) x $N ] } 1..$N;
        unless ($piece eq 'K') {
            @D2 = reverse @D1 = map { [$_ .. $N+$_-1] } 0..$N-1;
            @D2x = @D1x = (false) x ((2*$N)-1);
        }
        $Min = 2**31 - 1;
        my $nSQ   = $N**2;
        for my $max (1..$nSQ) {
            place_piece($piece, 0, $max);
            last if $Min <= $nSQ
        }
        printf("%2d x %-2d : %d\n", $N, $N, $Min);
        if ($N == $Limits{$piece}) {
            printf "\n%s on a %d x %d board:\n", $Names{$piece}, $N, $N;
            say $Layout and last
        }
    }
}
