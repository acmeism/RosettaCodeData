# clean up on exit, reset ANSI codes, scroll, re-show the cursor & clear screen
signal(SIGINT).tap: { print "\e[0m", "\n" xx 50, "\e[H\e[J\e[?25h"; exit(0) }

# a list of glyphs to use
my @codes = flat 'Α' .. 'Π', 'Ѐ' .. 'ѵ', 'Ҋ' .. 'ԯ', 'Ϣ' .. 'ϯ', 'ｦ'.. 'ﾝ',
                 'Ⲁ' .. '⳩', '∀' .. '∗', '℀' .. '℺', '⨀' .. '⫿';

# palette of gradient ANSI foreground colors
my @palette = flat  "\e[38;2;255;255;255m", (255,245 … 30).map({"\e[38;2;0;$_;0m"}),
              "\e[38;2;0;25;0m" xx 75;

my @screen; # buffer to hold glyphs
my @rotate; # palette rotation position buffer

my ($rows, $cols) = qx/stty size/.words; # get the terminal size
init($rows, $cols); # set up the screen buffer and palette offsets

my $size-check;

print "\e[?25l\e[48;5;232m"; # hide the cursor, set the background color

loop {
     if ++$size-check %% 20 {                         # periodically check for
         my ($r, $c) = qx/stty size/.words;           # resized terminal and
         init($r, $c) if $r != $rows or $c != $cols;  # re-initialize screen buffer
         $size-check = 0
     }
     print "\e[1;1H";                                 # set cursor to top left
     print join '', (^@screen).map: {
         @rotate[$_] = (@rotate[$_] + 1) % +@palette; # rotate the palettes
         flat @palette[@rotate[$_]], @screen[$_]      # and print foreground, glyph
     }
     @screen[(^@screen).pick] = @codes.roll for ^30;  # replace some random glyphs
}

sub init ($r, $c) {
    @screen = @codes.roll($r * $c);
    ($rows, $cols) = $r, $c;
    my @offset = (^@palette).pick xx $cols;
    for ^$rows -> $row {
        @rotate[$row * $cols ..^ $row * $cols + $cols] = @offset;
        # for no "lightning" effect, add   '1 + '  ↓ here: (1 + $_ % 3)
        @offset = (^@offset).map: {(@offset[$_] - ($_ % 3)) % +@palette};
    }
}
