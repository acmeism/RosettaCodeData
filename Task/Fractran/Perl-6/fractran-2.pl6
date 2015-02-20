constant FT2 = FT.grep: { not $_ +& ($_ - 1) }
for 1..* -> $i {
    given FT2[$i] {
        say $i, "\t", .msb, "\t", $_;
    }
}
