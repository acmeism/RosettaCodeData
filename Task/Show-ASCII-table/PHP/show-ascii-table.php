<?php

echo '+' . str_repeat('----------+', 6), PHP_EOL;
for ($j = 0 ; $j < 16 ; $j++) {
    for ($i = 0 ; $i < 6 ; $i++) {
        $val = 32 + $i * 16 + $j;
        switch ($val) {
            case  32: $chr = 'Spc';      break;
            case 127: $chr = 'Del';      break;
            default:  $chr = chr($val) ; break;
        }
        echo sprintf('| %3d: %3s ', $val, $chr);
    }
    echo '|', PHP_EOL;
}
echo '+' . str_repeat('----------+', 6), PHP_EOL;
