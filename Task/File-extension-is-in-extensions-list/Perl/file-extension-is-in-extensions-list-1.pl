sub check_extension {
    my ($filename, @extensions) = @_;
    my $extensions = join '|', map quotemeta, @extensions;
    scalar $filename =~ / \. (?: $extensions ) $ /xi
}
