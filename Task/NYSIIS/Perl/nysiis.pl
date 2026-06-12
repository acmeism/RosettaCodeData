sub no_suffix {
    my($name) = @_;
    $name =~ s/\h([JS]R)|([IVX]+)$//i;
    return uc $name;
}

sub nysiis {
    my($name) = @_;
    local($_) = uc $name;

    s/[^A-Z]//g;
    s/^MAC/MCC/;
    s/^P[FH]/FF/;
    s/^SCH/SSS/;
    s/^KN/N/;
    s/[IE]E$/Y/;
    s/[DRN]T$/D/;
    s/[RN]D$/D/;
    s/(.)EV/$1AF/g;
    s/(.)[AEIOU]+/$1A/g;
    s/(.)Q/$1G/g;
    s/(.)Z/$1S/g;
    s/(.)M/$1N/g;
    s/(.)KN/$1N/g;
    s/(.)K/$1C/g;
    s/(.)SCH/$1S/g;
    s/(.)PF/$1F/g;
    s/(.)K/$1C/g;
    s/(.)H([^AEIOU])/$1$2/g;
    s/([^AEIOU])H/$1/g;
    s/(.)W/$1/g;
    s/AY$/Y/;
    s/S$//;
    s/A$//;
    s/(.)\1+/$1/g;
    return $_;
}

for (
    "knight",     "mitchell",  "o'daniel",    "brown sr",   "browne III",
    "browne IV",  "O'Banion",  "Mclaughlin",  "McCormack",  "Chapman",
    "Silva",      "McDonald",  "Lawson",      "Jacobs",     "Greene",
    "O'Brien",    "Morrison",  "Larson",      "Willis",     "Mackenzie",
    "Carr",       "Lawrence",  "Matthews",    "Richards",   "Bishop",
    "Franklin",   "McDaniel",  "Harper",      "Lynch",      "Watkins",
    "Carlson",    "Wheeler",   "Louis XVI"
) {
    my $nysiis = nysiis no_suffix $_;
    $nysiis =~ s/^(......)(.*)$/$1\[$2\]/ if length($nysiis) > 6;
    printf "%10s,  %s\n", $_, $nysiis;
}
