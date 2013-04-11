<?php
function compose($f, $g) {
  return function($x) use ($f, $g) { return $f($g($x)); };
}

$trim_strlen = compose('strlen', 'trim');
echo $result = $trim_strlen(' Test '), "\n"; // prints 4
?>
