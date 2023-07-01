<?php
//Author Ivan Gavryushin @dcc0
$k=3;
$n=5;
//set amount of elements as in $n var
$c=array(1,2,3,4,5);
//set amount of 1 as in $k var
$b=array(1,1,1);
$j=$k-1;
//Вывод
	function printt($b,$k) {
	
	$z=0;

	while ($z < $k) print $b[$z++].' ';
	print '<br>';
}
printt ($b,$k);

        while (1) {
//Увеличение на позиции K до N

       	 if (array_search($b[$j]+1,$c)!==false ) {	     	
  	      	$b[$j]=$b[$j]+1;
        	printt ($b,$k);
       }

       	if ($b[$k-1]==$n) {
	 $i=$k-1;
//Просмотр массива справа налево
	 while ($i >= 0) {
		//Условие выхода
	 	if ( $i == 0 && $b[$i] == $n) break 2;
//Поиск элемента для увеличения
       		  $m=array_search($b[$i]+1,$c);
		if ($m!==false) {
		           $c[$m]=$c[$m]-1;
			  $b[$i]=$b[$i]+1;
		
			$g=$i;
//Сортировка массива B
		while ($g != $k-1) {
			array_unshift ($c, $b[$g+1]);
			$b[$g+1]=$b[$i];
			$g++;
			}
//Удаление повторяющихся значений из C
	                            $c=array_diff($c,$b);
				    printt ($b,$k);
                                    array_unshift ($c, $n);

		 	     break;
       			 }
	 	$i--;
	
		}

	}
}

?>
