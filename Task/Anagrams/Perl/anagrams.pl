use LWP::Simple;
use List::Util qw(max);

my @words = split(' ', get('http://www.puzzlers.org/pub/wordlists/unixdict.txt'));
my %anagram;
foreach my $word (@words) {
    push @{ $anagram{join('', sort(split(//, $word)))} }, $word;
}

my $count = max(map {scalar @$_} values %anagram);
foreach my $ana (values %anagram) {
    if (@$ana >= $count) {
        print "@$ana\n";
    }
}
