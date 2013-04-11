sub stripchars {
    my ($s, $chars) = @_;
    $s =~ s/[$chars]//g;
    return $s;
}

print stripchars("She was a soul stripper. She took my heart!", "aei"), "\n";
