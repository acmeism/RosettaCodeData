$fh = fopen($filename, 'r');
if ($fh) {
    while (!feof($fh)) {
        $line = rtrim(fgets($fh)); # removes trailing newline
        # process $line
    }
    fclose($fh);
}
