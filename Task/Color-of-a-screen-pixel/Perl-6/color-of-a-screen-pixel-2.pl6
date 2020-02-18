#!/usr/bin/env perl6

signal(SIGINT).tap: { sleep .1; cleanup(); print "\n" xx 50, "\e[H\e[J"; exit(0) }

multi MAIN () {
    use X11::libxdo;
    my $xdo = Xdo.new;
    my ($lx, $ly) = 0, 0;
    loop {
        sleep .1;
        my ($x, $y, $) = $xdo.get-mouse-location;
        next if $lx == $x and $ly == $y;
        ($lx, $ly) = $x, $y;
        display $x, $y, |get-pixel($x, $y);
    }
}

my %*SUB-MAIN-OPTS = :named-anywhere;

multi MAIN (
    Int $x,    #= Integer x coordinate to pick
    Int $y,    #= Integer y coordinate to pick
    $q = False #= Boolean "quiet" mode, set truthy for decimal values, set to h for hex values
  ) {
    my ($red, $green, $blue) = get-pixel($x, $y);

    if $q {
        $q.lc eq 'h' ??
          ( printf "%02X:%02X:%02X\n", $red, $green, $blue ) !!
          ( printf "%03d:%03d:%03d\n", $red, $green, $blue );
    } else {
        display($x, $y, $red, $green, $blue);
        cleanup();
    }
    exit(0);
}

sub get-pixel ($x, $y) {
    my $xcolor =
      qqx/import -window root -crop 1x1+{$x-1 max 0}+{$y-2 max 0} -depth 8 txt:-/
      .comb(/<?after '#'><xdigit> ** 6/);

    |$xcolor.comb(2)».parse-base(16);
}

sub display ($x, $y, $r, $g, $b) {
    print "\e[?25l\e[48;2;0;0;0m\e[38;2;255;255;255m\e[H\e[J";
    printf "  x: %4d y: $y\n", $x;
    printf "  RGB: %03d:%03d:%03d \n  HEX: %02X:%02X:%02X\n",
            $r, $g, $b, $r, $g, $b;
    print "\e[38;2;{$r};{$g};{$b}m ",
           ('█' x 18 xx 6).join("\n "), "\n\n";
}

sub cleanup { print "\e[0m\e[?25h" }
