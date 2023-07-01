use File::Spec::Functions qw(catfile rootdir);
my $size1 = -s 'input.txt';
my $size2 = -s catfile rootdir, 'input.txt';
