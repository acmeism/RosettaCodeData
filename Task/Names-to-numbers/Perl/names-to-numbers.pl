use strict;
use warnings;
use feature 'say';
use utf8;
binmode STDOUT, ':utf8';

my $phrases_with_numbers = <<'END';
One Hundred and One Dalmatians
Two Thousand and One: A Space Odyssey

Four  Score  And  Seven  Years  Ago
twelve dozen is one hundred forty-four, aka one gross
two hundred pairs of socks
Always give one hundred and ten percent effort
Change due: zero dollars and thirty-seven cents

One hour, fifty-nine minutes, forty point two seconds
π ≅ three point one four one five nine
END

my $pure_numbers = <<'END';
Twenty Nineteen
Two Thousand Nineteen
Two Thousand Zero Hundred and Nineteen
Two Thousand Ten Nine

one thousand one
ninety nine thousand nine hundred ninety nine
five hundred and twelve thousand, six hundred and nine
two billion, one hundred

One Thousand One Hundred Eleven
Eleven Hundred Eleven
one hundred eleven billion one hundred eleven
Eight Thousand Eight Hundred Eighty-Eight
Eighty-Eight Hundred Eighty-Eight

one quadrillion, two trillion, three billion, four million, five thousand six
END

my %nums = (
    zero        => 0,   one       => 1,     two      => 2,    three    => 3,
    four        => 4,   five      => 5,     six      => 6,    seven    => 7,
    eight       => 8,   nine      => 9,     ten      => 10,   eleven   => 11,
    twelve      => 12,  thirteen  => 13,    fourteen => 14,   fifteen  => 15,
    sixteen     => 16,  seventeen => 17,    eighteen => 18,   nineteen => 19,
    twenty      => 20,  thirty    => 30,    forty    => 40,   fifty    => 50,
    sixty       => 60,  seventy   => 70,    eighty   => 80,   ninety   => 90,
    hundred     => 100, thousand  => 1_000, million  => 1_000_000,
    billion     => 1_000_000_000,           trillion => 1_000_000_000_000,
    quadrillion => 1_000_000_000_000_000
);

# Groupings for thousands, millions, ... quadrillions
my $groups = qr/\d{4}|\d{7}|\d{10}|\d{13}|\d{16}/;

sub sum {
    my($values) = @_;
    my $sum = 0;
    $sum += $_ for split ' ', $values;
    $sum;
}

sub squeeze {
    my($str) = @_;
    $str =~ s/[\-\s]+/ /g;
    $str =~ s/^\s*(.*?)\s*$/$1/r;
}

# commify larger numbers for readabilty
sub comma {
    my($i) = @_;
    return $i if length($i) < 5;
    reverse ((reverse $i) =~ s/(.{3})/$1,/gr) =~ s/^,//r
}

sub numify {
    my($str) = @_;

    $str =~ tr/A-Z/a-z/;
    $str = squeeze($str);

    $str =~ s/(.)([[:punct:]])/$1 $2/g;

    foreach my $key (keys %nums) { $str =~ s/ \b $key \b /$nums{$key}/gx }

    $str =~ s/(\d+) \s+ (?=\d)/$1/gx if $str =~ /point (\d )+/;
    $str =~ s/(\d+) \s+ score / $1 * 20 /egx;

    $str =~ s/(\d) (?:,|and) (\d)/$1 $2/g;

    $str =~ s/\b (\d) \s+ 100 \s+ (\d\d) \s+ (\d) \s+    ($groups) \b / ($1 * 100 + $2 + $3) * $4 /egx;
    $str =~ s/\b (\d) \s+ 100 \s+ (\d{1,2}) \s+          ($groups) \b / ($1 * 100 + $2) * $3      /egx;
    $str =~ s/\b (\d) \s+ 100 \s+                        ($groups) \b /  $1 * 100 * $2            /egx;
    $str =~ s/\b      \s+ 100 \s+ (\d\d) \s+ (\d) \s+    ($groups) \b / ($1 + 100 + $2) * $3      /egx;
    $str =~ s/\b      \s+ 100 \s+ (\d{1,2}) \s+          ($groups) \b / ($1 + 100     ) * $2      /egx;
    $str =~ s/\b      \s+ 100 \s+                        ($groups) \b /  $1 * 100                 /egx;
    $str =~ s/\b                  (\d\d) \s+ (\d) \s+    ($groups) \b / ($1 + $2) * $3            /egx;
    $str =~ s/\b                  (\d{1,2}) \s+          ($groups) \b /  $1 * $2                  /egx;
    $str =~ s/\b                  (\d\d) \s+ (\d) \s+ 100          \b / ($1 + $2) * 100           /egx;
    $str =~ s/\b                  (\d{1,2}) \s+ 100                \b /  $1 * 100                 /egx;
    $str =~ s/\b                  (\d{2}) \s+ (\d{2})              \b /  $1 * 100 + $2            /egx;

    $str =~ s/((?:\d+ )*\d+)/sum $1/eg;

    $str =~ s/(\d+) \s+ pairs.of        /   $1 *  2 /egx;
    $str =~ s/(\d+) \s+ dozen           /   $1 * 12 /egx;
    $str =~ s/(\d+) \s+ point \s+ (\d+) /   $1.$2   /gx;
    $str =~ s/(\d+) \s+ percent         /   $1%     /gx;
    $str =~ s/(\d+) \s+ dollars         / \$$1      /gx;
    $str =~ s/(\d+) \s+ cents           /   $1¢     /gx;

    squeeze $str;
}

say $_ . ' --> ' .       numify($_) for grep { $_ } split "\n", $phrases_with_numbers;
say $_ . ' --> ' . comma numify($_) for grep { $_ } split "\n", $pure_numbers;
