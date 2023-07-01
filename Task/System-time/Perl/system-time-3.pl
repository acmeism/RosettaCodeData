use DateTime;
my $dt = DateTime->now;
my $d = $dt->ymd;
my $t = $dt->hms;
print "$d $t\n";
