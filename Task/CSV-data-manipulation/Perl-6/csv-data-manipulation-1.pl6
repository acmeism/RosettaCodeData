my $csvfile = './whatever.csv';
my $fh = open($csvfile, :r);
my @header = $fh.get.split(',');
my @csv = map {[.split(',')]>>.Num}, $fh.lines;
close $fh;

my $out = open($csvfile, :w);
$out.say((@header,'SUM').join(','));
$out.say((@$_, [+] @$_).join(',')) for @csv;
close $out;
