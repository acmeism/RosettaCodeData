<?php
function factorial($n) {
  if ($n < 0) {
    return 0;
  }

  $factorial = 1;
  for ($i = $n; $i >= 1; $i--) {
    $factorial = $factorial * $i;
  }

  return $factorial;
}
?>
