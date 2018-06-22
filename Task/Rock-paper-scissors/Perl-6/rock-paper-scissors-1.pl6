my %vs = (
    options => [<Rock Paper Scissors>],
    ro => {
        ro => [ 2, ''                        ],
        pa => [ 1, 'Paper covers Rock: '     ],
        sc => [ 0, 'Rock smashes Scissors: ' ]
    },
    pa => {
        ro => [ 0, 'Paper covers Rock: '    ],
        pa => [ 2, ''                       ],
        sc => [ 1, 'Scissors cut Paper: '   ]
    },
    sc => {
        ro => [ 1, 'Rock smashes Scissors: '],
        pa => [ 0, 'Scissors cut Paper: '   ],
        sc => [ 2, ''                       ]
    }
);

my %choices = %vs<options>.map({; $_.substr(0,2).lc => $_ });
my $keys    = %choices.keys.join('|');
my $prompt  = %vs<options>.map({$_.subst(/(\w\w)/, -> $/ {"[$0]"})}).join(' ')~"? ";
my %weight  = %choices.keys »=>» 1;

my @stats = 0,0,0;
my $round;

while my $player = (prompt "Round {++$round}: " ~ $prompt).lc {
    $player.=substr(0,2);
    say 'Invalid choice, try again.' and $round-- and next
      unless $player.chars == 2 and $player ~~ /<$keys>/;
    my $computer = (flat %weight.keys.map( { $_ xx %weight{$_} } )).pick;
    %weight{$_.key}++ for %vs{$player}.grep( { $_.value[0] == 1 } );
    my $result = %vs{$player}{$computer}[0];
    @stats[$result]++;
    say "You chose %choices{$player},  Computer chose %choices{$computer}.";
    print %vs{$player}{$computer}[1];
    print ( 'You win!', 'You Lose!','Tie.' )[$result];
    say " - (W:{@stats[0]} L:{@stats[1]} T:{@stats[2]})\n",
};
