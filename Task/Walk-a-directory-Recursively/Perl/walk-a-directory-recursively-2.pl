sub shellquote { "'".(shift =~ s/'/'\\''/gr). "'" }

sub find_files {
    my $dir = shellquote(shift);
    my $test = shellquote(shift);

    local $/ = "\0";
    open my $pipe, "find $dir -iname $test -print0 |" or die "find: $!.\n";
    while (<$pipe>) { print "$_\n"; }  # Here you could do something else with each file path, other than simply printing it.
    close $pipe;
}

find_files('.', '*.mp3');
