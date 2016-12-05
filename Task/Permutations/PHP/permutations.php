//Author Gavryushin Ivan @dcc0
<?php
$b="0123";
$a=strrev($b);

while ($a !=$b) {
$i=1;
	while($a[$i] > $a[$i-1]) {
	$i++;
}
$j=0;
	  while($a[$j] < $a[$i]) {
	
$j++;	
}
	  $c=$a[$j];
	  $a[$j]=$a[$i];
	  $a[$i]=$c;
	$a=strrev(substr($a, 0, $i)).substr($a, $i);
	print $a. "\n";

}
?>
