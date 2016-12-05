use DateTime::Format;

my $dt = DateTime.now;

say $dt.yyyy-mm-dd;
say strftime('%A, %B %d, %Y', $dt);
