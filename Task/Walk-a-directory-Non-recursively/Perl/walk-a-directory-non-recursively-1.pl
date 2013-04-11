use 5.010;
my $pattern = qr{ \A a }xmso; # match files whose first character is 'a'
opendir my $dh, 'the_directory';
say for grep { $pattern } readdir $dh;
closedir $dh;
