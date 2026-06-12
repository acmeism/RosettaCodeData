# 20260301 Raku programming solution

sub cyk-parse(@w, %r, $start --> Bool) {
   return False if ( my $n = @w.elems ) == 0;

   # Pre-index grammar: terminals and binary pairs
   my %term;   # Str terminal -> SetHash of LHS
   my %bin;    # Str "B␟C"    -> SetHash of LHS

   for %r.kv -> $lhs, @rules {
      for @rules -> @rhs {
         if @rhs.elems == 1 {
            (%term{@rhs[0]} //= SetHash.new).set($lhs)
         } elsif @rhs.elems == 2 {
            my $key = @rhs[0] ~ "\x1F" ~ @rhs[1];
            (%bin{$key} //= SetHash.new).set($lhs);
         } else {
            die "Not CNF: $lhs → {@rhs.raku}";
         }
      }
   }

   my @t = [ [ SetHash.new xx $n ] xx $n ]; # Chart table

   for ^$n -> $j { # Diagonal init: terminals
      if %term{@w[$j]}:exists { @t[$j][$j].set(%term{@w[$j]}.keys) }
   }

   for ^$n -> $j { # Fill spans of increasing length
      loop (my $i = $j - 1; $i >= 0; $i--) {
         for $i ..^ $j -> $k {
            # For each B in t[i,k] and C in t[k+1,j], add any A with A→BC.
            for @t[$i][$k].keys -> $B {
               for @t[$k+1][$j].keys -> $C {
                  my $key = $B ~ "\x1F" ~ $C;
                  next unless %bin{$key}:exists;
                  @t[$i][$j].set(%bin{$key}.keys)
               }
            }
         }
      }
   }
   return so @t[0][$n - 1]{$start};
}

my %r = (
   "NP"  => [ ["Det", "Nom"], ],
   "Nom" => [ ["AP", "Nom"], ["book"], ["orange"], ["man"] ],
   "AP"  => [ ["Adv", "A"], ["heavy"], ["orange"], ["tall"] ],
   "Det" => [ ["a"], ],
   "Adv" => [ ["very"], ["extremely"] ],
   "A"   => [ ["heavy"], ["orange"], ["tall"], ["muscular"] ],
);

my @tests = [
   "a very heavy orange book",
   "a very heavy orange",
   "a heavy orange",
   "a heavy",
   "orange",
   "very heavy orange"
];

for @tests -> $test { say cyk-parse($test.words, %r, "NP") }
