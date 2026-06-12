use Term::termios;

constant $saved   = Term::termios.new(fd => 1).getattr;
constant $termios = Term::termios.new(fd => 1).getattr;
# raw mode interferes with carriage returns, so
# set flags needed to emulate it manually
$termios.unset_iflags(<BRKINT ICRNL ISTRIP IXON>);
$termios.unset_lflags(<ECHO ICANON IEXTEN ISIG>);
$termios.setattr(:DRAIN);

END {
    $saved.setattr(:NOW); # reset terminal to original settings
    print "\e[?25h \e[H\e[J"; # clear and reset screen
}

my $row     = 3;
my $column  = 5;
my $field   = '';
my $spacer  = ' ' x 8;
my $pointer = 0;

my ($rows,$cols) = qx/stty size/.words; # get screen size

my @screen = "\e[41m{' ' x $cols}\e[0m" xx $rows;

update($spacer);

loop {
    my $key = $*IN.read(4).decode;
    given $key {
        when ' '..'~' {
            if $pointer < 8 {
                $field ~= $_;
                $spacer = ' ' x 8 - $field.chars;
                $pointer +=1;
                update($field~$spacer)
            } elsif $pointer >= 8 {
                $field ~= $_;
                $spacer = '';
                update($field.substr(*-8))
            }
        }
        when "\c[127]" { # backspace
            if $pointer > 0 {
                $field.=substr(0,*-1);
                $spacer = ' ' x (8 - $field.chars max 0);
                $pointer -= 1 if $field.chars < 8;
                my $display = $field.chars < 8 ?? $field !! $field.substr(*-8);
                update($display~$spacer)
            }
        }
        when "\c[13]" {
            update('        ');
            print "\e[10;6H\e[1;33;41mYou entered: $field\e[0m\e[$row;{$column}H";
            $field = '';
            $pointer = 0;
        }
        when "\c[0003]" { exit } # Ctrl-c
        default { }
    }
}

sub update ($str) {
    ($rows,$cols) = qx/stty size/.words;
    @screen = "\e[41m{' ' x $cols}\e[0m" xx $rows;
    print "\e[H\e[J{@screen.join: "\n"}\e[$row;{$column}H$str\e[$row;{$column + $pointer}H";
}
