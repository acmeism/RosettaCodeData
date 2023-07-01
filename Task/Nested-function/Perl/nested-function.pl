sub makeList {
    my $separator = shift;
    my $counter = 1;

    sub makeItem { $counter++ . $separator . shift . "\n" }

    makeItem("first") . makeItem("second") . makeItem("third")
}

print makeList(". ");
