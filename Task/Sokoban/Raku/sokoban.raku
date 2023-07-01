sub MAIN() {
    my $level = q:to//;
#######
#     #
#     #
#. #  #
#. $$ #
#.$$  #
#.#  @#
#######

    say 'level:';
    print $level;
    say 'solution:';
    say solve($level);
}

class State {
    has Str $.board;
    has Str $.sol;
    has Int $.pos;

    method move(Int $delta --> Str) {
        my $new = $!board;
        if $new.substr($!pos,1) eq '@' {
            substr-rw($new,$!pos,1) = ' ';
        } else {
            substr-rw($new,$!pos,1) = '.';
        }
        my $pos := $!pos + $delta;
        if $new.substr($pos,1) eq ' ' {
            substr-rw($new,$pos,1) = '@';
        } else {
            substr-rw($new,$pos,1) = '+';
        }
        return $new;
    }

    method push(Int $delta --> Str) {
        my $pos := $!pos + $delta;
        my $box := $pos + $delta;
        return '' unless $!board.substr($box,1) eq ' ' | '.';
        my $new = $!board;
        if $new.substr($!pos,1) eq '@' {
            substr-rw($new,$!pos,1) = ' ';
        } else {
            substr-rw($new,$!pos,1) = '.';
        }
        if $new.substr($pos,1) eq '$' {
            substr-rw($new,$pos,1) = '@';
        } else {
            substr-rw($new,$pos,1) = '+';
        }
        if $new.substr($box,1) eq ' ' {
            substr-rw($new,$box,1) = '$';
        } else {
            substr-rw($new,$box,1) = '*';
        }
        return $new;
    }
}

sub solve(Str $start --> Str) {
    my $board = $start;
    my $width = $board.lines[0].chars + 1;
    my @dirs =
        ["u", "U", -$width],
        ["r", "R", 1],
        ["d", "D", $width],
        ["l", "L", -1];

    my %visited = $board => True;

    my $pos = $board.index('@');
    my @open = State.new(:$board, :sol(''), :$pos);
    while @open {
        my $state = @open.shift;
        for @dirs -> [$move, $push, $delta] {
            my $board;
            my $sol;
            my $pos = $state.pos + $delta;
            given $state.board.substr($pos,1) {
                when '$' | '*' {
                    $board = $state.push($delta);
                    next if $board eq "" || %visited{$board};
                    $sol = $state.sol ~ $push;
                    return $sol unless $board ~~ /<[ . + ]>/;
                }
                when ' ' | '.' {
                    $board = $state.move($delta);
                    next if %visited{$board};
                    $sol = $state.sol ~ $move;
                }
                default { next }
            }
            @open.push: State.new: :$board, :$sol, :$pos;
            %visited{$board} = True;
        }
    }
    return "No solution";
}
