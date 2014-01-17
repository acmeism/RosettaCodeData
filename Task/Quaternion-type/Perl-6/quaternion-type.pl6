class Quaternion {
    has Real ( $.r, $.i, $.j, $.k );

    multi method new ( Real $r, Real $i, Real $j, Real $k ) {
        self.bless: :$r, :$i, :$j, :$k;
    }
    multi qu(*@r) is export { Quaternion.new: |@r }
    sub postfix:<j>(Real $x) is export { qu 0, 0, $x, 0 }
    sub postfix:<k>(Real $x) is export { qu 0, 0, 0, $x }

    method Str   () { "$.r + {$.i}i + {$.j}j + {$.k}k" }
    method reals () { $.r, $.i, $.j, $.k }
    method conj  () { qu $.r, -$.i, -$.j, -$.k }
    method norm  () { sqrt [+] self.reals X** 2 }

    multi infix:<eqv> ( Quaternion $a, Quaternion $b ) is export { $a.reals eqv $b.reals }

    multi infix:<+> ( Quaternion $a,       Real $b ) is export { qu $b+$a.r, $a.i, $a.j, $a.k }
    multi infix:<+> (       Real $a, Quaternion $b ) is export { qu $a+$b.r, $b.i, $b.j, $b.k }
    multi infix:<+> ( Quaternion $a,    Complex $b ) is export { qu $b.re + $a.r, $b.im + $a.i, $a.j, $a.k }
    multi infix:<+> (    Complex $a, Quaternion $b ) is export { qu $a.re + $b.r, $a.im + $b.i, $b.j, $b.k }
    multi infix:<+> ( Quaternion $a, Quaternion $b ) is export { qu $a.reals Z+ $b.reals }

    multi prefix:<-> ( Quaternion $a ) is export { qu $a.reals X* -1 }

    multi infix:<*> ( Quaternion $a,       Real $b ) is export { qu $a.reals X* $b }
    multi infix:<*> (       Real $a, Quaternion $b ) is export { qu $b.reals X* $a }
    multi infix:<*> ( Quaternion $a,    Complex $b ) is export { $a * qu $b.reals, 0, 0 }
    multi infix:<*> ( Complex $a,    Quaternion $b ) is export { $b R* qu $a.reals, 0, 0 }

    multi infix:<*> ( Quaternion $a, Quaternion $b ) is export {
	my @a_rijk            = $a.reals;
	my ( $r, $i, $j, $k ) = $b.reals;
	return qu [+]( @a_rijk Z* $r, -$i, -$j, -$k ), # real
		  [+]( @a_rijk Z* $i,  $r,  $k, -$j ), # i
		  [+]( @a_rijk Z* $j, -$k,  $r,  $i ), # j
		  [+]( @a_rijk Z* $k,  $j, -$i,  $r ); # k
    }
}
import Quaternion;

my $q  = 1 + 2i + 3j + 4k;
my $q1 = 2 + 3i + 4j + 5k;
my $q2 = 3 + 4i + 5j + 6k;
my $r  = 7;

say "1) q norm  = {$q.norm}";
say "2) -q      = {-$q}";
say "3) q conj  = {$q.conj}";
say "4) q  + r  = {$q + $r}";
say "5) q1 + q2 = {$q1 + $q2}";
say "6) q  * r  = {$q  * $r}";
say "7) q1 * q2 = {$q1 * $q2}";
say "8) q1q2 { $q1 * $q2 eqv $q2 * $q1 ?? '==' !! '!=' } q2q1";
