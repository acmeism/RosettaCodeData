$max = 1000;
$sum = 0;
for ($i = 1 ; $i < $max ; $i++) {
    if (($i % 3 == 0) or ($i % 5 == 0)) {
        $sum += $i;
    }
}
echo $sum, PHP_EOL;
