# 20201110 Raku programming solution

sub pancake(\n) {
   my ($gap,$sum,$adj) = 2, 2, -1;
   while ($sum < n) { $sum += $gap = $gap * 2 - 1 and $adj++ }
   return n + $adj;
}

for (1..20).rotor(5) { say [~] @_».&{ sprintf "p(%2d) = %2d ",$_,pancake $_ } }
