<?php //Josephus.php
function Jotapata($n=41,$k=3,$m=1){$m--;
	$prisoners=array_fill(0,$n,false);//make a circle of n prisoners, store false ie: dead=false
	$deadpool=1;//count to next execution
	$order=0;//death order and *dead* flag, ie. deadpool
	while((array_sum(array_count_values($prisoners))<$n)){//while sum of count of unique values dead times < n (they start as all false)
		foreach($prisoners as $thisPrisoner=>$dead){
			if(!$dead){//so yeah...if not dead...
				if($deadpool==$k){//if their time is up in the deadpool...
					$order++;
					//set the deadpool value or enumerate as survivor
					$prisoners[$thisPrisoner]=((($n-$m)>($order)?$order:(($n)==$order?'Call me *Titus Flavius* Josephus':'Joe\'s friend '.(($order)-($n-$m-1)))));
					$deadpool=1;//reset count to next execution
				}else{$duckpool++;}
			}
		}
	}
	return $prisoners;
}
echo '<pre>'.print_r(Jotapata(41,3,5),true).'<pre>';
