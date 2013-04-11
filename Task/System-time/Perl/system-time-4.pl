use POSIX qw(strftime);

$now_string = strftime "%a %b %e %H:%M:%S %Y", localtime;
print "$now_string\n";
