use Lingua::EN::Numbers;

for (1e2, 30, 1e6, 15, 1e9, 10, 7123, 25)».Int -> $start, $count {
    put "\nFirst $count gapful numbers starting at {comma $start}:\n" ~
    <Sir Lord Duke King>.pick ~ ": ", ~
    ($start..*).grep( { $_ %% .comb[0, *-1].join } )[^$count];
}
