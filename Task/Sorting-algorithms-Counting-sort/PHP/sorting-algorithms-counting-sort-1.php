<?php

function counting_sort(&$arr, $min, $max)
{
  $count = array();
  for($i = $min; $i <= $max; $i++)
  {
    $count[$i] = 0;
  }

  foreach($arr as $number)
  {
    $count[$number]++;
  }
  $z = 0;
  for($i = $min; $i <= $max; $i++) {
    while( $count[$i]-- > 0 ) {
      $arr[$z++] = $i;
    }
  }
}
