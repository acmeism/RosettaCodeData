my %prec = (
    '^' => 4,
    '*' => 3,
    '/' => 3,
    '+' => 2,
    '-' => 2,
    '(' => 1
);

my %assoc = (
    '^' => 'right',
    '*' => 'left',
    '/' => 'left',
    '+' => 'left',
    '-' => 'left'
);

sub shunting_yard {
    my @inp = split ' ', $_[0];
    my @ops;
    my @res;

    my $report = sub { printf "%25s    %-7s %10s %s\n", "@res", "@ops", $_[0], "@inp" };
    my $shift  = sub { $report->("shift @_");  push @ops, @_ };
    my $reduce = sub { $report->("reduce @_"); push @res, @_ };

    while (@inp) {
        my $token = shift @inp;
        if    ( $token =~ /\d/ ) { $reduce->($token) }
        elsif ( $token eq '(' )  { $shift->($token) }
        elsif ( $token eq ')' ) {
            while ( @ops and "(" ne ( my $x = pop @ops ) ) { $reduce->($x) }
        } else {
            my $newprec = $prec{$token};
            while (@ops) {
                my $oldprec = $prec{ $ops[-1] };
                last if $newprec > $oldprec;
                last if $newprec == $oldprec and $assoc{$token} eq 'right';
                $reduce->( pop @ops );
            }
            $shift->($token);
        }
    }
    $reduce->( pop @ops ) while @ops;
    @res;
}

local $, = " ";
print shunting_yard '3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3';
