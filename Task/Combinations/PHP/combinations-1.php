 <?php
//Author: I. Gavryushin aka dcc0
//set amount of elements as in $n var
$a=array(1,2,3,4,5);
$k=3;
$n=5;
$c=array_splice($a, $k);
$b=array_splice($a, 0, $k);
$j=$k-1;
print_r($b);

        while (1) {
	
       		$m=array_search($b[$j]+1,$c);
       	     if ($m!==false) {
	     	$c[$m]-=1;
        	$b[$j]=$b[$j]+1;
               	print_r($b);	
        }
       	if ($b[$k-1]==$n) {
	 $i=$k-1;
	 while ($i >= 0) {

	 		if ($i == 0 && $b[$i] == $n-$k+1) break 2;
	
       		  $m=array_search($b[$i]+1,$c);
		  if ($m!==false) {
		  	  $c[$m]=$c[$m]-1;
			  $b[$i]=$b[$i]+1;

			$g=$i;
		while ($g != $k-1) {
			array_unshift ($c, $b[$g+1]);
			$b[$g+1]=$b[$g]+1;
			$g++;
			}
			$c=array_diff($c,$b);
			print_r($b);
		 	     break;
       			 }
	 	$i--;
	
		}
	
	}
	

}

?>
