sub cartesian {
    my $sets = shift @_;
    for (@$sets) { return [] unless @$_ }

    my $products = [[]];
    for my $set (reverse @$sets) {
        my $partial = $products;
        $products = [];
        for my $item (@$set) {
            for my $product (@$partial) {
                push @$products, [$item, @$product];
            }
        }
    }
    $products;
}

sub product {
    my($s,$fmt) = @_;
    my $tuples;
    for $a ( @{ cartesian( \@$s ) } ) { $tuples .= sprintf "($fmt) ", @$a; }
    $tuples . "\n";
}

print
product([[1, 2],      [3, 4]                  ], '%1d %1d'        ).
product([[3, 4],      [1, 2]                  ], '%1d %1d'        ).
product([[1, 2],      []                      ], '%1d %1d'        ).
product([[],          [1, 2]                  ], '%1d %1d'        ).
product([[1,2,3],     [30],   [500,100]       ], '%1d %1d %3d'    ).
product([[1,2,3],     [],     [500,100]       ], '%1d %1d %3d'    ).
product([[1776,1789], [7,12], [4,14,23], [0,1]], '%4d %2d %2d %1d')
