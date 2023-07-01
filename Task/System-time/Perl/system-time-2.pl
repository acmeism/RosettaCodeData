($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
printf("%04d-%02d-%02d %02d:%02d:%02d\n", $year + 1900, $mon + 1, $mday, $hour, $min, $sec
