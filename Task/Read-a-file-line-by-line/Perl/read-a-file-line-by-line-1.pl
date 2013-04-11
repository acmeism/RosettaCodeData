open(FOO, '<', 'foobar.txt') or die $!;
while (<FOO>) { # each line is stored in $_, with terminating newline
    chomp; # chomp, short for chomp($_), removes the terminating newline
    process($_);
}
close(FOO);
