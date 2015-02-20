<?php
  function combos($arr, $k) {
    if ($k == 0) {
      return array(array());
    }

    if (count($arr) == 0) {
      return array();
    }

    $head = $arr[0];

    $combos = array();
    $subcombos = combos($arr, $k-1);
    foreach ($subcombos as $subcombo) {
      array_unshift($subcombo, $head);
      $combos[] = $subcombo;
    }
    array_shift($arr);
    $combos = array_merge($combos, combos($arr, $k));
    return $combos;
  }

  $arr = array("iced", "jam", "plain");
  $result = combos($arr, 2);
  foreach($result as $combo) {
    echo implode(' ', $combo), "<br>";
  }
  $donuts = range(1, 10);
  $num_donut_combos = count(combos($donuts, 3));
  echo "$num_donut_combos ways to order 3 donuts given 10 types";
?>
