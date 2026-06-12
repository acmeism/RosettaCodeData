$n = scalar <>;

do_stuff(scalar <>) for 1..$n;

sub do_stuff { print $_[0] }
