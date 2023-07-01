my $size1 = (stat 'input.txt')[7];  # builtin stat() returns an array with file size at index 7
my $size2 = (stat '/input.txt')[7];
