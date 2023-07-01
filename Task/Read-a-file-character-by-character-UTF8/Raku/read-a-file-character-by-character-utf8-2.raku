my $filename = 'whatever';

my $in = open( $filename, :r ) orelse .die;

print $_ while defined $_ = $in.getc;
