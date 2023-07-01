use utf8;
use Time::HiRes qw(sleep);
use Term::ANSIColor qw(colored);
use Term::ReadKey qw(ReadMode ReadLine);

binmode(STDOUT, ':utf8');

use constant {
              VOID => 0,
              HEAD => 1,
              BODY => 2,
              TAIL => 3,
              FOOD => 4,
             };

use constant {
              LEFT  => [+0, -1],
              RIGHT => [+0, +1],
              UP    => [-1, +0],
              DOWN  => [+1, +0],
             };

use constant {
              BG_COLOR  => "on_black",
              SLEEP_SEC => 0.05,
             };

use constant {
              SNAKE_COLOR => ('bold green' . ' ' . BG_COLOR),
              FOOD_COLOR  => ('red'        . ' ' . BG_COLOR),
             };

use constant {
    U_HEAD => colored('▲', SNAKE_COLOR),
    D_HEAD => colored('▼', SNAKE_COLOR),
    L_HEAD => colored('◀', SNAKE_COLOR),
    R_HEAD => colored('▶', SNAKE_COLOR),

    U_BODY => colored('╹', SNAKE_COLOR),
    D_BODY => colored('╻', SNAKE_COLOR),
    L_BODY => colored('╴', SNAKE_COLOR),
    R_BODY => colored('╶', SNAKE_COLOR),

    U_TAIL => colored('╽', SNAKE_COLOR),
    D_TAIL => colored('╿', SNAKE_COLOR),
    L_TAIL => colored('╼', SNAKE_COLOR),
    R_TAIL => colored('╾', SNAKE_COLOR),

    A_VOID => colored(' ',   BG_COLOR),
    A_FOOD => colored('❇', FOOD_COLOR),
             };

local $| = 1;

my $w = eval { `tput cols` }  || 80;
my $h = eval { `tput lines` } || 24;
my $r = "\033[H";

my @grid = map {
    [map { [VOID] } 1 .. $w]
} 1 .. $h;

my $dir      = LEFT;
my @head_pos = ($h / 2, $w / 2);
my @tail_pos = ($head_pos[0], $head_pos[1] + 1);

$grid[$head_pos[0]][$head_pos[1]] = [HEAD, $dir];    # head
$grid[$tail_pos[0]][$tail_pos[1]] = [TAIL, $dir];    # tail

sub create_food {
    my ($food_x, $food_y);

    do {
        $food_x = rand($w);
        $food_y = rand($h);
    } while ($grid[$food_y][$food_x][0] != VOID);

    $grid[$food_y][$food_x][0] = FOOD;
}

create_food();

sub display {
    my $i = 0;

    print $r, join("\n",
        map {
            join("",
                map {
                    my $t = $_->[0];
                    if ($t != FOOD and $t != VOID) {
                        my $p = $_->[1];
                        $i =
                            $p eq UP   ? 0
                          : $p eq DOWN ? 1
                          : $p eq LEFT ? 2
                          :              3;
                    }
                        $t == HEAD ? (U_HEAD, D_HEAD, L_HEAD, R_HEAD)[$i]
                      : $t == BODY ? (U_BODY, D_BODY, L_BODY, R_BODY)[$i]
                      : $t == TAIL ? (U_TAIL, D_TAIL, L_TAIL, R_TAIL)[$i]
                      : $t == FOOD ? (A_FOOD)
                      :              (A_VOID);

                  } @{$_}
                )
          } @grid
    );
}

sub move {
    my $grew = 0;

    # Move the head
    {
        my ($y, $x) = @head_pos;

        my $new_y = ($y + $dir->[0]) % $h;
        my $new_x = ($x + $dir->[1]) % $w;

        my $cell = $grid[$new_y][$new_x];
        my $t    = $cell->[0];

        if ($t == BODY or $t == TAIL) {
            die "Game over!\n";
        }
        elsif ($t == FOOD) {
            create_food();
            $grew = 1;
        }

        # Create a new head
        $grid[$new_y][$new_x] = [HEAD, $dir];

        # Replace the current head with body
        $grid[$y][$x] = [BODY, $dir];

        # Save the position of the head
        @head_pos = ($new_y, $new_x);
    }

    # Move the tail
    if (not $grew) {
        my ($y, $x) = @tail_pos;

        my $pos   = $grid[$y][$x][1];
        my $new_y = ($y + $pos->[0]) % $h;
        my $new_x = ($x + $pos->[1]) % $w;

        $grid[$y][$x][0]         = VOID;    # erase the current tail
        $grid[$new_y][$new_x][0] = TAIL;    # create a new tail

        # Save the position of the tail
        @tail_pos = ($new_y, $new_x);
    }
}

ReadMode(3);
while (1) {
    my $key;
    until (defined($key = ReadLine(-1))) {
        move();
        display();
        sleep(SLEEP_SEC);
    }

    if    ($key eq "\e[A" and $dir ne DOWN ) { $dir = UP    }
    elsif ($key eq "\e[B" and $dir ne UP   ) { $dir = DOWN  }
    elsif ($key eq "\e[C" and $dir ne LEFT ) { $dir = RIGHT }
    elsif ($key eq "\e[D" and $dir ne RIGHT) { $dir = LEFT  }
}
