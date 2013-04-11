sub partitions {
        my $sum = 0;
        $sum += $_ for @_;              # total number of elements
        make_part (     $_[-1],         # desired partition size
                        0,              # initial trial position
                        [ (0) x $sum ], # table recording of used element
                        [],             # current pick for current partition
                        [       $#_,    # total number of partitions
                                \@_,    # partition sizes
                                []      # for output, each partition's elements
                        ]               # Note: last group of args wrapped in array ref
        );                              #       to reduce argument passing overhead
}

sub make_part {
        my ($n, $pos, $used, $picked, $more) = @_;
        return if $pos > @$used;

        # the making-next-partition part
        if (!$n) {
                my ($part_idx, $sizes, $q) = @$more;
                push @$q, $picked;
                if ($part_idx > 1) {
                        make_part($sizes->[$part_idx-1], 0, $used, [],
                                        [ $part_idx-1, $sizes, $q]);
                } else {
                        my @x = grep { !$used->[$_] } 0 .. (@$used-1);
                        print "[ @$_ ]" for @$q;
                        print "[ @x ]\n";
                }
                pop @$q;
                return;
        }

        # the picking-element-to-make-partition part
        for my $i ($pos .. @$used - 1) {
                next if $used->[$i];
                push @$picked, $i;
                $used->[$i] = 1;

                make_part($n - 1, $i + 1, $used, $picked, $more);

                $used->[$i] = 0;
                pop @$picked;
        }
}

partitions(4, 2, 4);
