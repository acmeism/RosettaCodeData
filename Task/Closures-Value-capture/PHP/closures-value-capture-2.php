<?php
$funcs = array();
for ($i = 0; $i < 10; $i++) {
    $funcs[] = function () use ($i) { return $i * $i; };
}
echo $funcs[3](), "\n"; // prints 9
?>
