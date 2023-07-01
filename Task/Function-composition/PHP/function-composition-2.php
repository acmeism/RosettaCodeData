<?php
function compose($f, $g) {
  return create_function('$x', 'return '.var_export($f,true).'('.var_export($g,true).'($x));');
}

$trim_strlen = compose('strlen', 'trim');
echo $result = $trim_strlen(' Test '), "\n"; // prints 4
?>
