unit sub MAIN (:$war where 2..4 = 4, :$sleep = .1);

my %c = ( # convenience hash of ANSI colors
    red   => "\e[38;2;255;10;0m",
    blue  => "\e[38;2;05;10;200m",
    black => "\e[38;2;0;0;0m"
);

my @cards = flat (flat
     <🂢 🂣 🂤 🂥 🂦 🂧 🂨 🂩 🂪 🂫 🂭 🂮 🂡
      🃒 🃓 🃔 🃕 🃖 🃗 🃘 🃙 🃚 🃛 🃝 🃞 🃑>.map({ "{%c<black>}$_" }),
     <🂲 🂳 🂴 🂵 🂶 🂷 🂸 🂹 🂺 🂻 🂽 🂾 🂱
      🃂 🃃 🃄 🃅 🃆 🃇 🃈 🃉 🃊 🃋 🃍 🃎 🃁>.map({ "{%c<red>}$_" })
).batch(13).map({ .flat Z 2..14 })».map: { .[1] but .[0] };

my $back = "{%c<blue>}🂠";
my @won  = <👈 👉>;

sub shuffle (@cards) { @cards.pick: * }
sub deal    (@cards) { [@cards[0,*+2 … *], @cards[1,*+2 … *]] }

my ($rows, $cols) = qx/stty size/.words».Int; # get the terminal size
note "Terminal is only $cols characters wide, needs to be at least 80, 120 or more recommended."
  and exit if $cols < 80;

sub clean-up {
    reset-scroll-region;
    show-cursor;
    print-at $rows, 1, '';
    print "\e[0m";
    exit(0)
}

signal(SIGINT).tap: { clean-up() }

my @index  = ($cols div 2 - 5, $cols div 2 + 4);
my @player = (deal shuffle @cards)».Array;
my $lose   = False;

sub take (@player, Int $cards) {
    if +@player >= $cards {
        return @player.splice(0, $cards);
    }
    else {
         $lose = True;
         return @player.splice(0, +@player);
    }
}

use Terminal::ANSI;

clear-screen;
hide-cursor;
# Set background color
print "\e[H\e[J\e[48;2;245;245;245m", ' ' xx $rows * $cols + 1;

# Add header
print-at 1, $cols div 2 - 1, "{%c<red>}WAR!";
print-at 2, 1, '━' x $cols;

my $row = 3;
my $height = $rows - $row - 2;
set-scroll-region($row, $height);

# footer
print-at $height + 1, 1, '━' x $cols;

my $round = 0;
my @round;

loop {
    @round = [@player[0].&take(1)], [@player[1].&take(1)] unless +@round;
    print-at $row, $cols div 2, "{%c<red>}┃";
    print-at $row, @index[0], @round[0;0] // ' ';
    print-at $row, @index[1], @round[1;0] // ' ';
    if $lose {
        if @player[0] < @player[1] {
            print-at $row, $cols div 2 + 1, @won[1] unless +@round[1] == 1;
            print-at $height + 3, $cols div 2 - 10, "{%c<red>} Player 1 is out of cards "
        } else {
            print-at $row, $cols div 2 - 2, @won[0] unless +@round[0] == 1;
            print-at $height + 3, $cols div 2 - 10, "{%c<red>} Player 2 is out of cards "
        }

    }
    if (@round[0].tail // 0) > (@round[1].tail // 0) {
        print-at $row, $cols div 2 - 2, @won[0];
        @player[0].append: flat (|@round[0],|@round[1]).pick: *;
        @round = ();
    }
    elsif (@round[0].tail // 0) < (@round[1].tail // 0) {
        print-at $row, $cols div 2 + 1, @won[1];
        @player[1].append: flat (|@round[0],|@round[1]).pick: *;
        @round = ();
    }
    else {
        @round[0].append: @player[0].&take($war);
        @round[1].append: @player[1].&take($war);
        print-at $row, @index[0] - $_ * 2, ($_ %% $war) ?? @round[0; $_] !! $back for ^@round[0];
        print-at $row, @index[1] + $_ * 2, ($_ %% $war) ?? @round[1; $_] !! $back for ^@round[1];
        next
    }
    last if $lose;
    print-at $height + 2, $cols div 2 - 4,  "{%c<blue>} Round {++$round} ";
    print-at $height + 2, $cols div 2 - 40, "{%c<blue>} Player 1: {+@player[0]} cards ";
    print-at $height + 2, $cols div 2 + 21, "{%c<blue>} Player 2: {+@player[1]} cards ";
    sleep $sleep if +$sleep;
    if $row >= $height { scroll-up } else { ++$row }
}

# game over
print-at $height + 2, $cols div 2 - 40, "{%c<blue>} Player 1: {+@player[0] ?? '52' !! "{%c<red>}0"}{%c<blue>} cards ";
print-at $height + 2, $cols div 2 + 20, "{%c<blue>} Player 2: {+@player[1] ?? '52' !! "{%c<red>}0"}{%c<blue>} cards ";
clean-up;
