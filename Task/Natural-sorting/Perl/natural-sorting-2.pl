use utf8;        # interpret this script's source code as UTF8
use Test::More;  # for plan(), is_deeply()
use Data::Dump;  # for dd()

my @testcases = (
    ['Leading spaces',   '%sleading spaces: %i',  map {' ' x $_} 2, 3, 1, 0             ],
    ['Adjacent spaces',  'adjacent%s spaces: %i', map {' ' x $_} 2, 3, 1, 0             ],
    ['Different spaces', 'equiv.%sspaces: %i',    split //, "\x0b\n\t\x0c\r "           ],
    ['Case differences', '%s INDEPENENT: %i',     'casE', 'case', 'caSE', 'cASE'        ],
    ['Numeric fields',   'foo%ibar%ibaz%i.txt',   [100, 10, 0], [100, 99, 0],
                                                  [1000,99,9], [1000,99,10]             ],
    ['Title case',       '%s',                    'The 39 steps', 'The 40th step more',
                                                  'Wanda', 'The Wind in the Willows'    ],
    ['Accents',          'Equiv. %s accents: %i', 'y', 'Y', "\x{dd}", "\x{fd}"          ],
    ['Ligatures',        '%s',                    "Ĳ ligatured ij", 'no ligature'       ],
    ['Alternate forms',  'Start with an %s: %i',  's', 'ſ', 'ß'                         ],
);

plan tests => scalar @testcases;

foreach (@testcases) {
    my ($name, $pattern, @args) = @$_;
    my $i = 0;
    my @strings = map { sprintf $pattern, ref $_ ? @$_ : $_, $i++ } @args;

    is_deeply( [natural_sort(reverse sort @strings)], \@strings, $name );

    dd @strings;
    print "\n";
}
