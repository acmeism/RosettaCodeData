use DateTime;
my $dt = DateTime->now;
say $dt->iso8601();
say $dt->year_with_christian_era();
say $dt->year_with_secular_era();
# etc.
