opendir my $handle, '.' or die "Couldnt open current directory: $!";
while (readdir $handle) {
    print "$_\n";
}
closedir $handle;
