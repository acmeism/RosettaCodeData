use 5.010;
opendir my $dh, '/home/foo/bar';
say for grep { /php$/ } readdir $dh;
closedir $dh;
