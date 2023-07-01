use List::Util 'max';

my @words = split "\n", do { local( @ARGV, $/ ) = ( 'unixdict.txt' ); <> };
my %anagram;
for my $word (@words) {
    push @{ $anagram{join '', sort split '', $word} }, $word;
}

my $count = max(map {scalar @$_} values %anagram);
for my $ana (values %anagram) {
    print "@$ana\n" if @$ana == $count;
}
