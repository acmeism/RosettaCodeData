<?php
$funcs = array();
for ($i = 0; $i < 10; $i++) {
    $funcs[] = create_function('', '$i = ' . var_export($i, true) . '; return $i * $i;');
}
echo $funcs[3](), "\n"; // prints 9
?>
