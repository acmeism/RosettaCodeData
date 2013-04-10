use HTML::Entities;

sub row {
    my $elem = shift;
    my @cells = map {"<$elem>$_</$elem>"} split ',', shift;
    print '<tr>', @cells, "</tr>\n";
}

my ($first, @rest) = map
    {my $x = $_; chomp $x; encode_entities $x}
    <STDIN>;
print "<table>\n";
row @ARGV ? 'th' : 'td', $first;
row 'td', $_ foreach @rest;
print "</table>\n";
