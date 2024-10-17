function genMinAbbr(array $days): array {
    $len = 0;
    while(true) {
    	$dict = [];
    	$len++;
        foreach($days as $day) {
        	$abbr = substr($day, 0, $len);
        	if (isset($dict[$abbr])) continue 2;
        	$dict[$abbr] = true;
        }
        return array_keys($dict);
    }
}

foreach(explode("\n", file_get_contents("days-of-the-week.txt")) as $line) {
    if (!$line) { echo "\n"; continue; }
    echo implode(" ", genMinAbbr(explode(" ", $line))) . "\n";
}
