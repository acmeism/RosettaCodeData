class Quaternion {
    has Real ( $.r, $.i, $.j, $.k );

    multi method new ( Real $r, Real $i, Real $j, Real $k ) {
        self.bless: *, :$r, :$i, :$j, :$k;
    }
    method Str   (  ) { "$.r + {$.i}i + {$.j}j + {$.k}k" }
    method reals (  ) { $.r, $.i, $.j, $.k }
    method conj  (  ) { self.new: $.r, -$.i, -$.j, -$.k }
    method norm  (  ) { sqrt [+] self.reals X** 2 }
}

subset Qu of Quaternion; # Makes a short alias

multi sub  infix:<eqv> ( Qu $a, Qu $b ) { [and] $a.reals Z== $b.reals }
multi sub  infix:<+> ( Qu $a, Real $b ) { $a.new: $b+$a.r, $a.i, $a.j, $a.k }
multi sub  infix:<+> ( Real $a, Qu $b ) { $b.new: $a+$b.r, $b.i, $b.j, $b.k }
multi sub  infix:<+> ( Qu $a,   Qu $b ) { $a.new: |( $a.reals Z+ $b.reals ) }
multi sub prefix:<-> ( Qu $a          ) { $a.new: |( $a.reals X* -1 ) }
multi sub  infix:<*> ( Qu $a, Real $b ) { $a.new: |( $a.reals X* $b ) }
multi sub  infix:<*> ( Real $a, Qu $b ) { $b.new: |( $b.reals X* $a ) }
multi sub  infix:<*> ( Qu $a,   Qu $b ) {
    my @a_rijk            = $a.reals;
    my ( $r, $i, $j, $k ) = $b.reals;
    return $a.new: ( [+] @a_rijk Z* $r, -$i, -$j, -$k ), # real
                   ( [+] @a_rijk Z* $i,  $r,  $k, -$j ), # i
                   ( [+] @a_rijk Z* $j, -$k,  $r,  $i ), # j
                   ( [+] @a_rijk Z* $k,  $j, -$i,  $r ); # k
}

my Quaternion $q  .= new: 1, 2, 3, 4;
my Quaternion $q1 .= new: 2, 3, 4, 5;
my Quaternion $q2 .= new: 3, 4, 5, 6;
my $r  = 7;

say "1) q norm  = {$q.norm}";
say "2) -q      = {-$q}";
say "3) q conj  = {$q.conj}";
say "4) q  + r  = {$q + $r}";
say "5) q1 + q2 = {$q1 + $q2}";
say "6) q  * r  = {$q  * $r}";
say "7) q1 * q2 = {$q1 * $q2}";
say "8) q1q2 { $q1 * $q2 eqv $q2 * $q1 ?? '==' !! '!=' } q2q1";
