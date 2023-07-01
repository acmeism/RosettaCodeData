my %*SUB-MAIN-OPTS = :named-anywhere;

sub MAIN (*@parameters, Int :$goal = 24) {
    my @numbers;
    if +@parameters == 1 {
        @numbers = @parameters[0].comb(/\d/);
        USAGE() and exit unless 2 < @numbers < 5;
    } elsif +@parameters > 4 {
        USAGE() and exit;
    } elsif +@parameters == 3|4 {
        @numbers = @parameters;
        USAGE() and exit if @numbers.any ~~ /<-[-\d]>/;
    } else {
        USAGE();
        exit if +@parameters == 2;
        @numbers = 3,3,8,8;
        say 'Running demonstration with: ', |@numbers, "\n";
    }
    solve @numbers, $goal
}

sub solve (@numbers, $goal = 24) {
    my @operators = < + - * / >;
    my @ops   = [X] @operators xx (@numbers - 1);
    my @perms = @numbers.permutations.unique( :with(&[eqv]) );
    my @order = (^(@numbers - 1)).permutations;
    my @sol;
    @sol[250]; # preallocate some stack space

    my $batch = ceiling +@perms/4;

    my atomicint $i;
    @perms.race(:batch($batch)).map: -> @p {
        for @ops -> @o {
            for @order -> @r {
                my $result = evaluate(@p, @o, @r);
                @sol[$i⚛++] = $result[1] if $result[0] and $result[0] == $goal;
            }
        }
    }
    @sol.=unique;
    say @sol.join: "\n";
    my $pl = +@sol == 1 ?? '' !! 's';
    my $sg = $pl ?? '' !! 's';
    say +@sol, " equation{$pl} evaluate{$sg} to $goal using: {@numbers}";
}

sub evaluate ( @digit, @ops, @orders ) {
    my @result = @digit.map: { [ $_, $_ ] };
    my @offset = 0 xx +@orders;

    for ^@orders {
        my $this  = @orders[$_];
        my $order = $this - @offset[$this];
        my $op    = @ops[$this];
        my $result = op( $op, @result[$order;0], @result[$order+1;0] );
        return [ NaN, Str ] unless defined $result;
        my $string = "({@result[$order;1]} $op {@result[$order+1;1]})";
        @result.splice: $order, 2, [ $[ $result, $string ] ];
        @offset[$_]++ if $order < $_ for ^@offset;
    }
    @result[0];
}

multi op ( '+', $m, $n ) { $m + $n }
multi op ( '-', $m, $n ) { $m - $n }
multi op ( '/', $m, $n ) { $n == 0 ?? fail() !! $m / $n }
multi op ( '*', $m, $n ) { $m * $n }

my $txt = "\e[0;96m";
my $cmd = "\e[0;92m> {$*EXECUTABLE-NAME} {$*PROGRAM-NAME}";
sub USAGE {
    say qq:to
    '========================================================================'
    {$txt}Supply 3 or 4 integers on the command line, and optionally a value
    to equate to.

    Integers may be all one group: {$cmd} 2233{$txt}
          Or, separated by spaces: {$cmd} 2 4 6 7{$txt}

    If you wish to supply multi-digit or negative numbers, you must
        separate them with spaces: {$cmd} -2 6 12{$txt}

    If you wish to use a different equate value,
    supply a new --goal parameter: {$cmd} --goal=17 2 -3 1 9{$txt}

    If you don't supply any parameters, will use 24 as the goal, will run a
    demo and will show this message.\e[0m
    ========================================================================
}
