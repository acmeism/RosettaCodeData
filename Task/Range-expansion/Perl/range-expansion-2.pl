sub rangex {
    (my $range = shift) =~ s/(?<=\d)-/../g;
    eval $range;
}
