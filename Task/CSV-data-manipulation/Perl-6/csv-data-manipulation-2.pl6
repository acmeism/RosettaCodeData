use Text::CSV;
my $csvfile = './whatever.csv';
my @csv = Text::CSV.parse-file($csvfile);
# modify(@csv); # do whatever;
csv-write-file( @csv, :file($csvfile) );
