# 20260401 Raku programming solution

class BalancedTernary {
   # Digits as an array of (-1, 0, 1). Index 0 is the Most Significant Digit.
   has Int @.dig is rw;
   has Int $.p   is rw = 0;
   constant MAX_PRECISION = 81;

   multi method new(Str $s is copy) {
      return self.bless(
         p   => $s.chars - 1 - $s.index('.'),
         dig => ($s.subst('.', '')).comb.map: { when '-' { -1 }
                                                when '+' {  1 }
                                                default  {  0 } } )
   }

   multi method new(Int $n) {
      my ($abs-n, @d) = $n.abs;
      if $n == 0 { return self.bless: dig => [0], p => 0 }

      $abs-n == 0  # Convert to standard base 3
         ?? ( @d = [0] )
         !! do loop (my $tmp=$abs-n;$tmp > 0;$tmp div= 3) { @d.unshift($tmp%3) }

      if $n < 0 { @d .= map(* * -1) } # Apply sign
      return self.bless(dig => @d, p => 0).canonicalize;
   }

   multi method new(Real $x) {
      if $x == 0 { return self.new(0) }
      given self.new( ($x * (3 ** MAX_PRECISION)).round ) {
         .p = MAX_PRECISION and return .canonicalize
      }
   }

   multi method new() { return self.bless(dig => [0], p => 0) }

   # Helper to create object without re-parsing
   method create-raw(@d, $p) { return self.bless(dig => @d, p => $p) }

   # Core Logic
   method canonicalize() {
      loop (my $i = @!dig.end; $i >= 0; $i--) { # from Right (LSB) to Left (MSB)
         if @!dig[$i] > 1 {
            @!dig[$i] -= 3;
            if $i == 0 {
               @!dig.unshift(1);
               $i++; # Adjust index to stay on current digit
            } else {
               @!dig[$i - 1] += 1;
            }
         } elsif @!dig[$i] < -1 {
            @!dig[$i] += 3;
            if $i == 0 {
               @!dig.unshift(-1);
               $i++; # Adjust index
            } else {
               @!dig[$i - 1] -= 1;
            }
         }
      }

      while @!dig.elems > 1 && @!dig[0] == 0 { @!dig.shift } # Trim leading 0s

      while $!p > 0 && @!dig.elems > 0 && @!dig[*-1] == 0 { # Trim if decimal
         @!dig.pop;
         $!p--
      }
      if @!dig.elems == 0 { @!dig = [0] }
      return self
   }

   method Str() {
      self.canonicalize;
      my $s = @!dig.map({ when -1 { '-' }
                          when 0  { '0' }
                          when 1  { '+' } }).join;
      if $!p > 0 {
         $s = do if $!p < $s.chars {
            $s.substr(0, * - $!p) ~ "." ~ $s.substr(* - $!p);
         } elsif $!p == $s.chars {
            "0." ~ $s;
         } else {
            "0." ~ ("0" x ($!p - $s.chars)) ~ $s;
         }
      }
      return $s
   }

   method to-BigFloat() {
      my ($val, $int-val) = 0.0, 0;
      for @!dig -> $d { $int-val = $int-val * 3 + $d }
      return $int-val / (3 ** $!p)
   }

   method neg() { return self.create-raw(@!dig.map(* * -1).Array, $!p) }

   method add(BalancedTernary $b) {
      my (@a-dig, @b-dig) := @!dig, $b.dig; # local copies

      my $p-diff = $!p - $b.p; # Align decimal points (Pad Right)
      given $p-diff { when * > 0 { @b-dig.append: |(0 xx  $p-diff) }
                      when * < 0 { @a-dig.append: |(0 xx -$p-diff) } }

      my $len-diff = @a-dig.elems - @b-dig.elems; # Align INT parts (Pad Left)
      given $len-diff { when * > 0 { @b-dig.unshift: |(0 xx  $len-diff) }
                        when * < 0 { @a-dig.unshift: |(0 xx -$len-diff) } }
      my @sum = gather for 0..@a-dig.end -> $i { take @a-dig[$i] + @b-dig[$i] }

      return self.create-raw(@sum, max($!p, $b.p)).canonicalize
   }

   method mul(BalancedTernary $b) {
      my $res = self.new(0);

      for 0..$b.dig.end -> $i { # Convolution
         # Iterate B digits from right to left
         my $digit = $b.dig[$b.dig.end - $i];
         next if $digit == 0;

         my @partial = @!dig.map(* * $digit); # Multiply A by current digit
         @partial.append: |(0 xx $i); # Shift Left (Pad Right with zeros)

         $res += self.create-raw(@partial, 0) # (treat as integer for addition)
      }
      $res.p = $!p + $b.p; # Set final precision
      return $res.canonicalize
   }
}

multi sub  infix:<+>(BalancedTernary $a, BalancedTernary $b) { $a.add($b) }
multi sub  infix:<->(BalancedTernary $a, BalancedTernary $b) { $a + (-$b) }
multi sub  infix:<*>(BalancedTernary $a, BalancedTernary $b) { $a.mul($b) }
multi sub prefix:<->(BalancedTernary $a) { $a.neg }

sub code-reuse-task($T) {
   my $a = $T.new("+-0++0+.+-0++0+");
   my $b = $T.new(-436.436e0);
   my $c = $T.new("+-++-.+-++-");

   say " a = {$a.Str} = {$a.to-BigFloat.fmt("%.5f")}";
   say " b = {$b.Str} = {$b.to-BigFloat.fmt("%.5f")}";
   say " c = {$c.Str} = {$c.to-BigFloat.fmt("%.5f")}";

   my $result = $a * ($b - $c);

   say "\na * (b - c) = {$result.Str}";
   say " = {$result.to-BigFloat.fmt("%.5f")}";

   say "\n           Multiplication 27 X 12";
   say " x|+ (1)  |+- (2) |+0 (3) |++ (4) |+-- (5)|+-0 (6)|+-+ (7)|+0- (8)|+e+-(9)|+0+(10)|++-(11)|++0(12)|";

   for 1..27 -> $i {
      printf "%2d|", $i;
      for 1..12 -> $j { printf "%7s|",  ($T.new($i) * $T.new($j)).Str }
      print "\n"
   }
}

code-reuse-task(BalancedTernary);
