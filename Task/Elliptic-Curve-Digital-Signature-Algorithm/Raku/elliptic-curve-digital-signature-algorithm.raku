module EC {
  use FiniteField;

  our class Point {
    has ($.x, $.y);
    submethod TWEAK { fail unless $!y**2 == $!x**3 + $*a*$!x + $*b }
    multi method gist(::?CLASS:U:) { "Point at Horizon" }
    multi method new($x, $y) { samewith :$x, :$y }
  }
  multi infix:<==>(Point:D $A, Point:D $B) is export { $A.x == $B.x and $A.y == $B.y }

  multi prefix:<->(Point $P) returns Point is export { Point.new: $P.x, -$P.y }
  multi infix:<+>(Point $A, Point:U) is export { $A }
  multi infix:<+>(Point:U, Point $B) is export { $B }
  multi infix:<+>(Point:D $A, Point:D $B) returns Point is export {
    my $λ;
    if $A.x == $B.x and $A.y == -$B.y { return Point }
    elsif $A == $B {
      return Point if $A.y == 0;
      $λ = (3*$A.x² + $*a) / (2*$A.y);
    }
    else { $λ = ($A.y - $B.y) / ($A.x - $B.x); }

    given $λ**2 - $A.x - $B.x {
      return Point.new: $_, $λ*($A.x - $_) - $A.y;
    }
  }
  multi infix:<*>(0, Point     ) is export { Point }
  multi infix:<*>(1, Point   $p) is export { $p }
  multi infix:<*>(2, Point:D $p) is export { $p + $p }
  multi infix:<*>(Int $n, Point $p) is export { 2*(($n div 2)*$p) + ($n mod 2)*$p }
}

import EC;

module ECDSA {
  use Digest::SHA256::Native;
  our class Signature {
    has UInt ($.c, $.d);
    multi method new(Str $message, UInt :$private-key) {
      my $z = :16(sha256-hex $message) % $*n;
      loop (my $k = my $s = my $r = 0; $r == 0; ) {
        loop ( $r = $s = 0 ; $r == 0 ; ) {
          $r = (( $k = (1..^$*n).roll ) * $*G).x % $*n;
        }
        {
          use FiniteField; my $*modulus = $*n;
          $s = ($z + $r*$private-key) / $k;
        }
      }
      samewith c => $r, d => $s;
    }
    multi method verify(Str $message, EC::Point :$public-key) {
      my $z = :16(sha256-hex $message) % $*n;
      my ($u1, $u2);
      {
        use FiniteField;
        my $*modulus = $*n;
        my $w = 1/$!d;
        ($u1, $u2) = $z*$w, $!c*$w;
      }
      my $p = ($u1 * $*G) + ($u2 * $public-key);
      die unless ($p.x mod $*n) == ($!c mod $*n);
    }
  }
}

my ($*a, $*b) = 355, 671;
my $*modulus = my $*p = 1073741789;

my $*G = EC::Point.new: 13693, 10088;
my $*n = 1073807281;

die "G is not of order n" if $*n*$*G;

my $private-key = ^$*n .pick;
my $public-key = $private-key*$*G;

my $message = "Show me the monKey";
my $signature = ECDSA::Signature.new: $message, :$private-key;

printf "The curve E is        : 𝑦² = 𝑥³ + %s 𝑥 + %s (mod %s)\n", $*a, $*b, $*p;
printf "with generator G at   : (%s, %s)\n", $*G.x, $*G.y;
printf "G's order is          : %d\n", $*n;
printf "The private key is    : %d\n", $private-key;
printf "The public key is at  : (%s, %s)\n", $public-key.x, $public-key.y;
printf "The message is        : %s\n", $message;
printf "The signature is      : (%s, %s)\n", $signature.c, $signature.d;

{
  use Test;

  lives-ok {
    $signature.verify: $message, :$public-key;
  }, "good signature for <$message>";

  my $altered = $message.subst(/monKey/, "money");
  dies-ok {
    $signature.verify: $altered, :$public-key
  }, "wrong signature for <$altered>";
}
