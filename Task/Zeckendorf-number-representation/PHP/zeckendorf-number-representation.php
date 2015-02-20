<?php
$m = 20;

$F = array(1,1);
while ($F[count($F)-1] <= $m)
   $F[] = $F[count($F)-1] + $F[count($F)-2];

while ($n = $m--) {
   while ($F[count($F)-1] > $n) array_pop($F);
   $l = count($F)-1;
   print "$n: ";
   while ($n) {
      if ($n >= $F[$l]) {
         $n = $n - $F[$l];
         print '1';
      } else print '0';
      --$l;
   }
   print str_repeat('0',$l);
   print "\n";
}
?>
