# 20240208 Raku programming solution

say sub ($k is copy, $n is copy) {
   my @s = [ [1] xx $k ].append: [0] xx ($n - $k);
   my $z = my $d = $n - $k;
   ($k, $n) = ($d, $k).minmax.bounds;

   while $z > 0 || $k > 1 {
      ^$k .map: { @s[$_].append: @s.splice(*-1) }
      ($z, $d) = ($z, $n) X- $k;
      ($k, $n) = ($d, $k).minmax.bounds;
   }
   return [~] @s>>.List.flat;
}(5, 13);
