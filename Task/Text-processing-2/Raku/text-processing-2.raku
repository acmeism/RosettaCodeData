my $good-records;
my $line;
my %dates;

for lines() {
    $line++;
    / ^
    (\d ** 4 '-' \d\d '-' \d\d)
    [ \h+ \d+'.'\d+ \h+ ('-'?\d+) ] ** 24
    $ /
        or note "Bad format at line $line" and next;
    %dates.push: $0 => $line;
    $good-records++ if $1.all >= 1;
}

say "$good-records good records out of $line total";

say 'Repeated timestamps (with line numbers):';
.say for sort %dates.pairs.grep: *.value.elems > 1;
