use Lingua::EN::Numbers;

for [2,3], 1, 2000,
    [2,3], 1, 50000,
    [2,3], 2, 2000,
    [2,3], 2, 50000
  -> @div, $sub, $limit {
    my %min = 1 => {:op(''), :v(1), :s(0)};
    (2..$limit).map( -> $n {
       my @ops;
       @ops.push: ($n / $_, "/$_") if $n %% $_ for @div;
       @ops.push: ($n - $sub, "-$sub") if $n > $sub;
       my $op = @ops.min( {%min{.[0]}<s>} );
       %min{$n} = {:op($op[1]), :v($op[0]), :s(1 + %min{$op[0]}<s>)};
    });

    my $max = %min.max( {.value<s>} ).value<s>;
    my @max = %min.grep( {.value.<s> == $max} )».key.sort(+*);

    if $limit == 2000 {
        say "\nDivisors: {@div.perl}, subtract: $sub";
        steps(1..10);
    }
    say "\nUp to {comma $limit} found {+@max} number{+@max == 1 ?? '' !! 's'} " ~
        "that require{+@max == 1 ?? 's' !! ''} at least $max steps.";
    steps(@max);

    sub steps (*@list) {
        for @list -> $m {
            my @op;
            my $n = $m;
            while %min{$n}<s> {
                @op.push: "{%min{$n}<op>}=>{%min{$n}<v>}";
                $n = %min{$n}<v>;
            }
            say "($m) {%min{$m}<s>} steps: ", @op.join(', ');
        }
    }
}
