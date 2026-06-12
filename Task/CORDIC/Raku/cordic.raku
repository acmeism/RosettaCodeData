# 2023082 Raku programming solution

sub CORDIC ($A is copy) {

   my (\Ten, $K, $X, $Y) = ( 1, * * 1/10 ... * )[^6], 0, 1, 0;

   my \Tbl = < 7.853981633974480e-1 9.966865249116200e-2 9.999666686665240e-3
               9.999996666668670e-4 9.999999966666670e-5 9.999999999666670e-6 0.0>;

   while $A > 1e-5 {
      $K++ while $A < Tbl[$K];
      $A -= Tbl[$K];
      ($X,$Y) = $X - Ten[$K]*$Y, $Y + Ten[$K]*$X;
   }
   return $X, sqrt($X*$X + $Y*$Y)
}

say "Angle    CORDIC       Cosine       Error";
for <-9 0 1.5 6> {
   my \result = [/] CORDIC .abs;
   printf "% 2.1f  "~"% 2.8f  " x 3~"\n", $_, result, .cos, .cos - result
}
