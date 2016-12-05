#!/usr/bin/env perl6
use v6;
#
# In this code, a sudoku puzzle is represented as a two-dimentional
# array. The cells that are not yet solved are represented by yet
# another array of all the possible values.
#
# This implementation is not a simple brute force evaluation of all
# the options, but rather makes four extra attempts to guide the
# solution:
#
#  1) For every change in the grid, usually made by an attempt at a
#     solution, we will reduce the search space of the possible values
#     in all the other cells before going forward.
#
#  2) When a cell that is not yet resolved is the only one that can
#     hold a specific value, resolve it immediately instead of
#     performing the regular search.
#
#  3) Instead of trying from cell 1,1 and moving in sequence, this
#     implementation will start trying on the cell that is the closest
#     to being solved already.
#
#  4) Instead of trying all possible values in sequence, start with
#     the value that is the most unique. I.e.: If the options for this
#     cell are 1,4,6 and 6 is only a candidate for two of the
#     competing cells, we start with that one.
#

# keep a list with all the cells, handy for traversal
my @cells = do for (flat 0..8 X 0..8) -> $x, $y { [ $x, $y ] };

#
# Try to solve this puzzle and return the resolved puzzle if it is at
# all solvable in this configuration.
sub solve($sudoku, Int $level) {
    # cleanup the impossible values first,
    if (cleanup-impossible-values($sudoku, $level)) {
        # try to find implicit answers
        while (find-implicit-answers($sudoku, $level)) {
            # and every time you find some, re-do the cleanup and try again
            cleanup-impossible-values($sudoku, $level);
        }
        # Now let's actually try to solve a new value. But instead of
        # going in sequence, we select the cell that is the closest to
        # being solved already. This will reduce the overall number of
        # guesses.
        for sort { solution-complexity-factor($sudoku, $_[0], $_[1]) },
        grep { $sudoku[$_[0]][$_[1]] ~~ Array },
        @cells -> $cell
        {
            my Int ($x, $y) = @($cell);
            # Now let's try the possible values in the order of
            # uniqueness.
            for sort { matches-in-competing-cells($sudoku, $x, $y, $_) }, @($sudoku[$x][$y]) -> $val {
                trace $level, "Trying $val on "~($x+1)~","~($y+1)~" "~$sudoku[$x][$y].perl;
                my $solution = clone-sudoku($sudoku);
                $solution[$x][$y] = $val;
                my $solved = solve($solution, $level+1);
                if $solved {
                    trace $level, "Solved... ($val on "~($x+1)~","~($y+1)~")";
                    return $solved;
                }
            }
            # if we fell through, it means that we found no valid
            # value for this cell
            trace $level, "Backtrack, path unsolvable... (on "~($x+1)~" "~($y+1)~")";
            return 0;
        }
        # all cells are already solved.
        return $sudoku;
    } else {
        # if the cleanup failed, it means this is an invalid grid.
        return False;
    }
}

# This function reduces the search space from values that are already
# assigned to competing cells.
sub cleanup-impossible-values($sudoku, Int $level = 1) {
    my Bool $resolved;
    repeat {
        $resolved = False;
        for grep { $sudoku[$_[0]][$_[1]] ~~ Array },
        @cells -> $cell {
            my Int ($x, $y) = @($cell);
            # which block is this cell in
            my Int $bx = Int($x / 3);
            my Int $by = Int($y / 3);

            # A unfilled cell is not resolved, so it shouldn't match
            my multi match-resolved-cell(Array $other, Int $this) {
                return 0;
            }
            my multi match-resolved-cell(Int $other, Int $this) {
                return $other == $this;
            }

            # Reduce the possible values to the ones that are still
            # valid
            my @r =
                grep { !match-resolved-cell($sudoku[any(0..2)+3*$bx][any(0..2)+3*$by], $_) }, # same block
                grep { !match-resolved-cell($sudoku[any(0..8)][$y], $_) }, # same line
                grep { !match-resolved-cell($sudoku[$x][any(0..8)], $_) }, # same column
                @($sudoku[$x][$y]);
            if (@r.elems == 1) {
                # if only one element is left, then make it resolved
                $sudoku[$x][$y] = @r[0];
                $resolved = True;
            } elsif (@r.elems == 0) {
                # This is an invalid grid
                return 0;
            } else {
                $sudoku[$x][$y] = @r;
            }
        }
    } while $resolved; # repeat if there was any change
    return 1;
}

sub solution-complexity-factor($sudoku, Int $x, Int $y) {
    my Int $bx = Int($x / 3); # this block
    my Int $by = Int($y / 3);
    my multi count-values(Array $val) {
        return $val.elems;
    }
    my multi count-values(Int $val) {
        return 1;
    }
    # the number of possible values should take precedence
    my Int $f = 1000 * count-values($sudoku[$x][$y]);
    for (flat 0..2 X 0..2) -> $lx, $ly {
        $f += count-values($sudoku[$lx+$bx*3][$ly+$by*3])
    }
    for 0..^($by*3), (($by+1)*3)..8 -> $ly {
        $f += count-values($sudoku[$x][$ly])
    }
    for 0..^($bx*3), (($bx+1)*3)..8 -> $lx {
        $f += count-values($sudoku[$lx][$y])
    }
    return $f;
}

sub matches-in-competing-cells($sudoku, Int $x, Int $y, Int $val) {
    my Int $bx = Int($x / 3); # this block
    my Int $by = Int($y / 3);
    # Function to decide which possible value to try first
    my multi cell-matching(Int $cell) {
        return $val == $cell ?? 1 !! 0;
    }
    my multi cell-matching(Array $cell) {
        return $cell.grep({ $val == $_ }) ?? 1 !! 0;
    }
    my Int $c = 0;
    for (flat 0..2 X 0..2) -> $lx, $ly {
        $c += cell-matching($sudoku[$lx+$bx*3][$ly+$by*3])
    }
    for 0..^($by*3), (($by+1)*3)..8 -> $ly {
        $c += cell-matching($sudoku[$x][$ly])
    }
    for 0..^($bx*3), (($bx+1)*3)..8 -> $lx {
        $c += cell-matching($sudoku[$lx][$y])
    }
    return $c;
}

sub find-implicit-answers($sudoku, Int $level) {
    my Bool $resolved = False;
    for grep { $sudoku[$_[0]][$_[1]] ~~ Array },
    @cells -> $cell {
        my Int ($x, $y) = @($cell);
        for @($sudoku[$x][$y]) -> $val {
            # If this is the only cell with this val as a possibility,
            # just make it resolved already
            if (matches-in-competing-cells($sudoku, $x, $y, $val) == 1) {
                $sudoku[$x][$y] = $val;
                $resolved = True;
            }
        }
    }
    return $resolved;
}

my $puzzle =
    map { [ map { $_ == 0 ?? [1..9] !! $_+0  }, @($_) ] },
    [ 0,0,0,0,3,7,6,0,0 ],
    [ 0,0,0,6,0,0,0,9,0 ],
    [ 0,0,8,0,0,0,0,0,4 ],
    [ 0,9,0,0,0,0,0,0,1 ],
    [ 6,0,0,0,0,0,0,0,9 ],
    [ 3,0,0,0,0,0,0,4,0 ],
    [ 7,0,0,0,0,0,8,0,0 ],
    [ 0,1,0,0,0,9,0,0,0 ],
    [ 0,0,2,5,4,0,0,0,0 ];

my $solved = solve($puzzle, 0);
if $solved {
    print-sudoku($solved,0);
} else {
    say "unsolvable.";
}

# Utility functions, not really part of the solution

sub trace(Int $level, Str $message) {
    say '.' x $level, $message;
}

sub clone-sudoku($sudoku) {
    my $clone;
    for (flat 0..8 X 0..8) -> $x, $y {
        $clone[$x][$y] = $sudoku[$x][$y];
    }
    return $clone;
}

sub print-sudoku($sudoku, Int $level = 1) {
    trace $level, '-' x 5*9;
    for @($sudoku) -> $row {
        trace $level, join " ", do for @($row) -> $cell {
            $cell ~~ Array ?? "#{$cell.elems}#" !! " $cell "
        }
    }
}
