<?php
foreach (range(0, 33) as $n) {
  echo decbin($n), "\t", decoct($n), "\t", $n, "\t", dechex($n), "\n";
}
?>
