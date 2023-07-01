<?php
function prime($a) {
  return !preg_match('/^1?$|^(11+?)\1+$/', str_repeat('1', $a));
}
?>
