use File::Find qw(find);
my $dir      = '.';
my $pattern  = 'foo';
my $callback = sub { print $File::Find::name, "\n" if /$pattern/ };
find $callback, $dir;
