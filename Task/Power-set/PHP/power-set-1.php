<?php
function get_subset($binary, $arr) {
  // based on true/false values in $binary array, include/exclude
  // values from $arr
  $subset = array();
  foreach (range(0, count($arr)-1) as $i) {
    if ($binary[$i]) {
      $subset[] = $arr[count($arr) - $i - 1];
    }
  }
  return $subset;
}

function print_array($arr) {
  if (count($arr) > 0) {
    echo join(" ", $arr);
  } else {
    echo "(empty)";
  }
  echo '<br>';
}

function print_power_sets($arr) {
  echo "POWER SET of [" . join(", ", $arr) . "]<br>";
  foreach (power_set($arr) as $subset) {
    print_array($subset);
  }
}

function power_set($arr) {
  $binary = array();
  foreach (range(1, count($arr)) as $i) {
    $binary[] = false;
  }
  $n = count($arr);
  $powerset = array();

  while (count($binary) <= count($arr)) {
    $powerset[] = get_subset($binary, $arr);
    $i = 0;
    while (true) {
      if ($binary[$i]) {
        $binary[$i] = false;
        $i += 1;
      } else {
        $binary[$i] = true;
        break;
      }
    }
    $binary[$i] = true;
  }

  return $powerset;
}

print_power_sets(array());
print_power_sets(array('singleton'));
print_power_sets(array('dog', 'c', 'b', 'a'));
?>
