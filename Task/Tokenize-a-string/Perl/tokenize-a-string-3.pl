BEGIN { $/ = "\n"; $\ = "\n"; }
LINE: while (defined($_ = <ARGV>)) {
    chomp $_;
    our(@F) = split(/,/, $_, 0);
    $" = '.';
    $_ = "@F";
}
continue {
    die "-p destination: $!\n" unless print $_;
}
