<?php
 //Author Ivan Gavryshin @dcc0
function tre($n) {
  $ck=1;
  $kn=$n+1;

 if($kn%2==0) {
 $kn=$kn/2;
 $i=0;
  }
 else
  {

  $kn+=1;
  $kn=$kn/2;
  $i= 1;
}

 for ($k = 1; $k <= $kn-1; $k++) {
   $ck = $ck/$k*($n-$k+1);
   $arr[] = $ck;
   echo  "+" . $ck ;

  }


if ($kn>1) {
  echo $arr[i];
  $arr=array_reverse($arr);
 for ($i; $i<= $kn-1; $i++) {
 echo  "+" . $arr[$i]  ;
     }

   }

 }
 //set amount of strings here
 while ($n<=20) {
 ++$n;
 echo tre($n);
 echo "<br/>";
}


?>
