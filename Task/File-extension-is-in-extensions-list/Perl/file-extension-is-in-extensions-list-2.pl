my @extensions = ('zip', 'rar', '7z', 'gz', 'archive', 'A##', 'tar.bz2');
my @files= (
    'MyData.a##', 'MyData.tar.Gz', 'MyData.gzip', 'MyData.7z.backup',
    'MyData...', 'MyData', 'MyData_v1.0.tar.bz2', 'MyData_v1.0.bz2'
);
printf "%-19s - %s\n",
    $_, check_extension($_, @extensions) ? 'true' : 'false'
    for @files;
