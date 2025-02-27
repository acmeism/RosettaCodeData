sub domino (Str $s) { $s.comb.sort.join }

sub solve ( UInt $rows, UInt $cols, @tab ) {
    die unless @tab.elems == $rows*$cols;
    die unless @tab.elems %% 2;

    my @orientations = 'A' xx @tab.elems; # [A]vailable,[R]ight,[D]own,[L]eft,[U]p

    my SetHash $hand .= new: map &domino, [X~] @tab.unique xx 2;

    return gather {
        my sub place_domino_at_first_available_after ( UInt $pos_last = 0 ) {
            my $p1 = $pos_last + @orientations.skip($pos_last).first(:k, 'A');

            for (False, $p1+1    , <L R>),
                (True , $p1+$cols, <D U>) -> ($is_down, $p2, @two_letters) {

                next if $p2 > @tab.end or (!$is_down && $p2 %% $cols); # Board boundaries.

                my @two_cells := @orientations[$p1, $p2]; # Bind to candidate location

                next if @two_cells !eqv <A A>; # Both cells must be available for placement.

                my $dom = domino( @tab[$p1, $p2].join );

                $hand{$dom}-- or next;          # Take domino from hand, iff present
                @two_cells = @two_letters;      # Assign placement

                # Either the solution is complete, or we must recurse.
                if !$hand { take @orientations.clone }
                else      { place_domino_at_first_available_after($p1) }

                @two_cells = <A A>;             # Unassign placement
                $hand{$dom}++;                  # Restore domino into hand
            }
        }
        place_domino_at_first_available_after();
    }
}
sub bonus ( UInt $rows, UInt $cols ) {
    die "Both are odd, so no tiling possible" if $rows !%% 2 and $cols !%% 2;

    my $half = $rows * $cols div 2;

    my sub T ($N) { map { ( pi * $_/($N+1) ).cos² * 4 }, 1..($N/2).ceiling }

    my $arrangements = [*] T($rows) X+ T($cols);
    my $flips        =     2 ** $half;
    my $permutations = [*] 1 .. $half;
    my $product      = [*] ($arrangements, $flips, $permutations);
    return :$arrangements, :$flips, :$permutations, :$product;
}
my @tests =
    (7, 8, '05132231055052464303662006235126113002452143346664515414'),
    (7, 8, '64220650162341432102355113505610426040114420536366525334'),
    (3, 4, '001102221201'),
;
sub solution_works ( UInt $rows, UInt $cols, @tab, @sol --> Bool ) {
    die unless @sol.all eq <L R U D>.any;
    my BagHash $b .= new;
    for @sol.keys -> $p1 {
        given @sol[$p1] {
            when 'L' { my $p2 = $p1+1;     die unless @sol[$p2] eq 'R'; $b{ domino( @tab[$p1,$p2].join ) }++; }
            when 'D' { my $p2 = $p1+$cols; die unless @sol[$p2] eq 'U'; $b{ domino( @tab[$p1,$p2].join ) }++; }
        }
    }
    die unless $b.values.max == 1 and $b.elems == $rows * $cols / 2;
    return True;
}
for @tests -> ( $rows, $cols, $flat_table ) {
    my @solutions = solve($rows, $cols, $flat_table.comb);
    say 'Solutions found: ', +@solutions;

    # Confirm that every solution is valid.
    solution_works($rows, $cols, $flat_table.comb, $_) or die for @solutions;

    # Print first solution
    say .join.trans( [<L R D U>] => [<╼ ╾ ╽ ╿>]) for @solutions[0].batch($cols);

    if ++$ == 1 {
        say 'Bonus:';
        say .value.fmt("%45d "), .key.tclc for bonus($rows, $cols);
        say '';
    }
}
