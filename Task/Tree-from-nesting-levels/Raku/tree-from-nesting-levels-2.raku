sub to_tree_recursive ( @list, $index is copy, $depth ) {
    my @so_far = gather while $index <= @list.end {
        my $t = @list[$index];

        given $t <=> $depth {
            when Order::Same {
                take $t;
            }
            when Order::More {
                ( $index, my $n1 ) = to_tree_recursive( @list, $index, $depth+1 );
                take $n1;
            }
            when Order::Less {
                $index--;
                last;
            }
        }
        $index++;
    }

    my $i = ($depth > 1) ?? $index !! -1;
    return $i, @so_far;
}
my @tests = (), (1, 2, 4), (3, 1, 3, 1), (1, 2, 3, 1), (3, 2, 1, 3), (3, 3, 3, 1, 1, 3, 3, 3);
say .Str.fmt( '%15s => ' ), to_tree_recursive( $_, 0, 1 ).[1] for @tests;
