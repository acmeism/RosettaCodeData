my $test-file1 = q:to/TEST1/;
Pi                250  BCE
Magic Squares     2200 BCE
Kwarizmi          830  CE
Dice              3000 BCE
Liber Abaci       1202 CE
Euclid's Elements 300  BCE
Euler's Number    1727 CE
The Abacus        1200 CE
TEST1

my $test-file2 = q:to/TEST2/;
Pi             250  BCE
Magic Squares  2200 BCE
Kwarizmi       830  CE
Dice           3000 BCE
Liber Abaci    1202 CE

Euler's Number 1727 CE
The Abacus     1200 CE

TEST2

for $test-file1, $test-file2 {
    .put for .lines.map( { next unless .chars; [.match(/ (.+) \s (\d+) \s (\s* 'B'?'CE') /).List] } )
    .sort: { .[2].contains('B') ?? -.[1] !! +.[1] };
    say '';
}
