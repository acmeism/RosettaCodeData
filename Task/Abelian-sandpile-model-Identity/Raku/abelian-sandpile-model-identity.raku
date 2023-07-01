class ASP {
    has $.h = 3;
    has $.w = 3;
    has @.pile = 0 xx $!w * $!h;

    method topple {
        my $buf = $!w * $!h;
        my $done;
        repeat {
            $done = True;
            loop (my int $row; $row < $!h; $row = $row + 1) {
                my int $rs = $row * $!w; # row start
                my int $re = $rs  + $!w; # row end
                loop (my int $idx = $rs; $idx < $re; $idx = $idx + 1) {
                    if self.pile[$idx] >= 4 {
                        my $grain = self.pile[$idx] div 4;
                        self.pile[ $idx - $!w ] += $grain if $row > 0;
                        self.pile[ $idx - 1  ]  += $grain if $idx - 1 >= $rs;
                        self.pile[ $idx + $!w ] += $grain if $row < $!h - 1;
                        self.pile[ $idx + 1  ]  += $grain if $idx + 1 < $re;
                        self.pile[ $idx ] %= 4;
                        $done = False;
                    }
                }
            }
        } until $done;
        self.pile;
    }
}

# some handy display layout modules
use Terminal::Boxer:ver<0.2+>;
use Text::Center;

for 3, (4,3,3,3,1,2,0,2,3), (2,1,2,1,0,1,2,1,2), # 3 square task example
    3, (2,1,2,1,0,1,2,1,2), (2,1,2,1,0,1,2,1,2), # 3 square identity
    5, (4,1,0,5,1,9,3,6,1,0,8,1,2,5,3,3,0,1,7,5,4,2,2,4,0), (2,3,2,3,2,3,2,1,2,3,2,1,0,1,2,3,2,1,2,3,2,3,2,3,2) # 5 square test
  -> $size, $pile, $identity {

    my $asp = ASP.new(:h($size), :w($size));

    $asp.pile = |$pile;

    my @display;

    my %p = :col($size), :3cw, :indent("\t");

    @display.push: rs-box |%p, |$identity;

    @display.push: rs-box |%p, $asp.pile;

    @display.push: rs-box |%p, $asp.topple;

    $asp.pile Z+= $identity.list;

    @display.push: rs-box |%p, $asp.pile;

    @display.push: rs-box |%p, $asp.topple;

    put %p<indent> ~ qww<identity 'test pile' toppled 'plus identity' toppled>».&center($size * 4 + 1).join: %p<indent>;

    .put for [Z~] @display».lines;

    put '';
}
