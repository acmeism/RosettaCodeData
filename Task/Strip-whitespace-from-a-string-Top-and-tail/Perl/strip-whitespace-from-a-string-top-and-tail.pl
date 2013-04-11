use strict;

sub ltrim
{
    my $c = shift;
    $c =~ s/^\s+//;
    return $c;
}

sub rtrim
{
    my $c = shift;
    $c =~ s/\s+$//;
    return $c;
}

sub trim
{
    my $c = shift;
    return ltrim(rtrim($c));
}

my $p = "       this is a string      ";

print "'", $p, "'\n";
print "'", trim($p), "'\n";
print "'", ltrim($p), "'\n";
print "'", rtrim($p), "'\n";
