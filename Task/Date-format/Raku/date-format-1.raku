use DateTime::Format;

my $dt = DateTime.now;

say strftime('%Y-%m-%d', $dt);
say strftime('%A, %B %d, %Y', $dt);
