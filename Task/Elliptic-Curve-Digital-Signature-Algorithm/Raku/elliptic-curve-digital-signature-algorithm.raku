use Digest::SHA256::Native;

# Following data taken from the C entry
our (\A,\B,\P,\O,\Gx,\Gy) = (355, 671, 1073741789, 1073807281, 13693, 10088);

#`{ Following data taken from the Julia entry; 256-bit; tested
our (\A,\B,\P,\O,\Gx,\Gy) = (0, 7, # https://en.bitcoin.it/wiki/Secp256k1
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F,
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141,
0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,
0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8); # }

role Horizon { method gist { 'EC Point at horizon' } }

class Point {             # modified from the Elliptic_curve_arithmetic entry
   has ($.x, $.y);        # handle modular arithmetic only
   multi method new( \x, \y ) { self.bless(:x, :y) }
   method gist { "EC Point at x=$.x, y=$.y" }
   method isOn { modP(B + $.x * modP(A+$.x²)) == modP($.y²) }
   sub modP ($a is copy) { ( $a %= P ) < 0 ?? ($a += P) !! $a }
}

multi infix:<⊞>(Point \p, Point \q) {
   my \λ = $; # slope
   if p.x ~~ q.x and p.y ~~ q.y {
      return Horizon if p.y == 0 ;
      λ = (3*p.x²+ A) * mult_inv(2*p.y, :modulo(P))
   } else {
      λ = (p.y - q.y) * mult_inv(p.x - q.x, :modulo(P))
   }
   my \xr = (λ²- p.x - q.x);
   my \yr = (λ*(p.x - xr) - p.y);
   return Point.bless: x =>  xr % P, y => yr % P
}

multi infix:<⊠>(Int \n, Point \p) {
   return 0                if n == 0 ;
   return p                if n == 1 ;
   return p ⊞ ((n-1) ⊠ p ) if n % 2 == 1 ;
   return ( n div 2 ) ⊠ ( p ⊞ p )
}

sub mult_inv($n, :$modulo) { # rosettacode.org/wiki/Modular_inverse#Raku
   my ($c, $d, $uc, $vd, $vc, $ud, $q) = $n % $modulo, $modulo, 1, 1, 0, 0, 0;
   while $c != 0 {
      ($q, $c, $d) = ($d div $c, $d % $c, $c);
      ($uc, $vc, $ud, $vd) = ($ud - $q*$uc, $vd - $q*$vc, $uc, $vc);
   }
   return $ud % $modulo;
}

class Signature {

   has ($.n, Point $.G); # Order and Generator point

   method generate_signature(Int \private_key, Str \msg) {
      my \z = :16(sha256-hex msg) % $.n; # self ref: Blob.list.fmt("%02X",'')
      loop ( my $k = my $s = my $r = 0 ; $s == 0 ; ) {
         loop ( $r = $s = 0 ; $r == 0 ; ) {
            $r = (( $k = (1..^$.n).roll ) ⊠ $.G).x % $.n;
         }
         $s = ((z + $r*private_key) * mult_inv $k, :modulo($.n)) % $.n;
      }
      return $r, $s, private_key ⊠ $.G ;
   }

   method verify_signature(\msg, \r, \s, \public_key) {
      my \z = :16(sha256-hex msg) % $.n;
      my \w = mult_inv s, :modulo($.n);
      my (\u1,\u2) = (z*w, r*w).map: { $_ % $.n }
      my \p = (u1 ⊠ $.G ) ⊞ (u2 ⊠ public_key);
      return (p.x % $.n) == (r % $.n)
   }
}

print "The Curve E is        : ";
"𝑦² = 𝑥³ + %s 𝑥 + %s (mod %s) \n".printf(A,B,P);
"with Generator G at   : (%s,%s)\n".printf(Gx,Gy);
my $ec = Signature.new: n => O, G => Point.new: x => Gx, y => Gy ;
say "Order(G, E) is        : ", O;
say "Is G  ∈ E ?           : ", $ec.G.isOn;
say "Message               : ", my \message = "Show me the monKey";
say "The private key dA is : ", my \dA = (1..^O).roll;
my ($r, $s, \Qa) = $ec.generate_signature(dA, message);
say "The public  key Qa is : ", Qa;
say "Is Qa ∈ E ?           : ", Qa.isOn;
say "Is signature valid?   : ", $ec.verify_signature(message, $r, $s, Qa);
say "Message (Tampered)    : ", my \altered = "Show me the money";
say "Is signature valid?   : ", $ec.verify_signature(altered, $r, $s, Qa)
