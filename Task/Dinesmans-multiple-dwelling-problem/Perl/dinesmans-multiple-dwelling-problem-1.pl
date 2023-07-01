use strict;
use warnings;
use feature <state say>;
use List::Util 1.33 qw(pairmap);
use Algorithm::Permute qw(permute);

our %predicates = (
#                       | object    | sprintf format for Perl expression |
#   --------------------+-----------+------------------------------------+
    'on bottom'      => [ ''        , '$f[%s] == 1'                      ],
    'on top'         => [ ''        , '$f[%s] == @f'                     ],
    'lower than'     => [ 'person'  , '$f[%s] < $f[%s]'                  ],
    'higher than'    => [ 'person'  , '$f[%s] > $f[%s]'                  ],
    'directly below' => [ 'person'  , '$f[%s] == $f[%s] - 1'             ],
    'directly above' => [ 'person'  , '$f[%s] == $f[%s] + 1'             ],
    'adjacent to'    => [ 'person'  , 'abs($f[%s] - $f[%s]) == 1'        ],
    'on'             => [ 'ordinal' , '$f[%s] == \'%s\''                 ],
);

our %nouns = (
    'person'  => qr/[a-z]+/i,
    'ordinal' => qr/1st | 2nd | 3rd | \d+th/x,
);

sub parse_and_solve {
    my @facts = @_;

    state $parser = qr/^(?<subj>$nouns{person}) (?<not>not )?(?|@{[
                            join '|', pairmap {
                                "(?<pred>$a)" .
                                ($b->[0] ? " (?<obj>$nouns{$b->[0]})" : '')
                            } %predicates
                        ]})$/;

    my (@expressions, %ids, $i);
    my $id = sub { defined $_[0] ? $ids{$_[0]} //= $i++ : () };

    foreach (@facts) {
        /$parser/ or die "Cannot parse '$_'\n";

        my $pred = $predicates{$+{pred}};
        { no warnings;
          my $expr = '(' . sprintf($pred->[1], $id->($+{subj}),
                           $pred->[0] eq 'person' ? $id->($+{obj}) : $+{obj}). ')';
          $expr = '!' . $expr if $+{not};
          push @expressions, $expr;
        }
    }

    my @f = 1..$i;
    eval '
          permute {
              say join(", ", pairmap { "$f[$b] $a" } %ids)
                  if ('.join(' && ', @expressions).');
          } @f;';
}
