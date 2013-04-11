run "ls" or die $!; # output to stdout

my @ls = qx/ls/;    # output to variable

my $cmd = 'ls';
my @ls = qqx/$ls/;  # same thing with interpolation
