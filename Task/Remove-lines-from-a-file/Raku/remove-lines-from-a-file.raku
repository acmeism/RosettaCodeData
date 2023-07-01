sub MAIN ($filename, $beg, $len) {
    my @lines = split /^^/, slurp $filename;
    unlink $filename;  # or rename
    splice(@lines,$beg,$len) == $len or warn "Too few lines";
    spurt $filename, @lines;
}
