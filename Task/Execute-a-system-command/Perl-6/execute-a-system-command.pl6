run "ls" orelse .die; # output to stdout

my @ls = qx/ls/;    # output to variable

my $cmd = 'ls';
@ls = qqx/$cmd/;  # same thing with interpolation
