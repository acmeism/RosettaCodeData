<?php
function factorial($n) {
  if ($n < 0) {
    return 0;
  }

  if ($n == 0) {
    return 1;
  }

  else {
    return $n * factorial($n-1);
  }
}
?>
