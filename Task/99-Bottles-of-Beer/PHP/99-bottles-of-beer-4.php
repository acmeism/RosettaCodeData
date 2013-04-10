<?php
  for($i=100;$i>0;$i--){
    $p2=$i." bottle".(($i>1)?"s":"")." of beer";
    $p1=$p2." on the wall\n";
    $p3="Take one down, pass it around\n";
    echo (($i<100)?$p1."\n":"").$p1.$p2."\n".$p3.(($i<2)?($i-1).substr($p1,1,28):"");
  }
