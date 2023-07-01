use List::MoreUtils 'natatime';
use constant FIELDS => 49;

binmode STDIN, ':crlf';
  # Read the newlines properly even if we're not running on
  # Windows.

my ($line, $good_records, %dates) = (0, 0);
while (<>)
   {++$line;
    my @fs = split /\s+/;
    @fs == FIELDS or die "$line: Bad number of fields.\n";
    for (shift @fs)
       {/\d{4}-\d{2}-\d{2}/ or die "$line: Bad date format.\n";
        ++$dates{$_};}
    my $iterator = natatime 2, @fs;
    my $all_flags_okay = 1;
    while ( my ($val, $flag) = $iterator->() )
       {$val =~ /\d+\.\d+/ or die "$line: Bad value format.\n";
        $flag =~ /\A-?\d+/ or die "$line: Bad flag format.\n";
        $flag < 1 and $all_flags_okay = 0;}
    $all_flags_okay and ++$good_records;}

print "Good records: $good_records\n",
   "Repeated timestamps:\n",
   map {"  $_\n"}
   grep {$dates{$_} > 1}
   sort keys %dates;
