$in = fopen("input.dat", "r");
fscanf($in, "%d %d\n", $a, $b); //Reads 2 numbers from file $in
fclose($in);

$out = fopen("output.dat", "w");
fwrite($out, ($a + $b) . "\n");
fclose($out);
