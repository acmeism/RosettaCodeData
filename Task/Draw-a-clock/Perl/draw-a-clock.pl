use utf8;                # interpret source code as UTF8
binmode STDOUT, ':utf8'; # allow printing wide chars without warning
$|++;                    # disable output buffering

my ($rows, $cols) = split /\s+/, `stty size`;
my $x = int($rows / 2 - 1);
my $y = int($cols / 2 - 16);

my @chars = map {[ /(...)/g ]}
            ("┌─┐  ╷╶─┐╶─┐╷ ╷┌─╴┌─╴╶─┐┌─┐┌─┐   ",
             "│ │  │┌─┘╶─┤└─┤└─┐├─┐  │├─┤└─┤ : ",
             "└─┘  ╵└─╴╶─┘  ╵╶─┘└─┘  ╵└─┘╶─┘   ");

while (1) {
    my @indices = map { ord($_) - ord('0') } split //,
                  sprintf("%02d:%02d:%02d", (localtime(time))[2,1,0]);

    clear();
    for (0 .. $#chars) {
      position($x + $_, $y);
      print "@{$chars[$_]}[@indices]";
    }
    position(1, 1);

    sleep 1;
}

sub clear { print "\e[H\e[J" }
sub position { printf "\e[%d;%dH", shift, shift }
