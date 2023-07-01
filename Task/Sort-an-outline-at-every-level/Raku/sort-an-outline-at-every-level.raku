my @tests = q:to/END/.split( /\n\n+/ )».trim;
zeta
    beta
    gamma
        lambda
        kappa
        mu
    delta
alpha
    theta
    iota
    epsilon

zeta
	gamma
		mu
		lambda
		kappa
	delta
	beta
alpha
	theta
	iota
	epsilon

alpha
    epsilon
	iota
    theta
zeta
    beta
    delta
    gamma
    	kappa
        lambda
        mu

zeta
    beta
   gamma
        lambda
         kappa
        mu
    delta
alpha
    theta
    iota
    epsilon
END

for @tests -> $t {
    say "{'=' x 55}\nUnsorted:\n$t";
    my $indent = try detect-indent $t;
    next unless $indent;
    say "\nSorted ascending:";
    pretty-print import($t, :level($indent) ).List, :ws($indent);
    say "\nSorted descending:";
    pretty-print import($t, :level($indent) ).List, :ws($indent), :desc;
}

sub detect-indent ($text) {
    my $consistent = $text.lines.map(* ~~ / ^ (\h*) /).join.comb.Set;
    note "\nUnwilling to continue; Inconsistent indent characters." and return '' if +$consistent > 1;
    my @ws = $text.lines.map: (* ~~ / ^ (\h*) /)».Str;
    my $indent = @ws.grep( *.chars > 0 ).min.first;
    note "\nUnwilling to continue; Inconsistent indentation." and return '' unless all
      @ws.map: { next unless .[0]; (.[0].chars %% $indent.chars) }
    $indent
}

sub import (Str $trees, :$level) {
    my $forest = '[';
    my $last = -Inf;
    for $trees.lines -> $branch {
        $branch ~~ / ($($level))* /;
        my $this = +$0;
        $forest ~= do {
            given $this cmp $last {
                when More { (?$this ?? q[ => \[ ] !! "" )~ "'{$branch.trim}'" }
                when Same { ", '{$branch.trim}'" }
                when Less { "{']' x $last - $this}, '{$branch.trim}' " }
            }
        }
        $last = $this;
    }
    $forest ~= ']' x 1 + $last;
    use MONKEY-SEE-NO-EVAL;
    $forest.EVAL;
}

multi pretty-print (List $struct, :$level = 0, :$ws = '    ', :$desc = False) {
    if $desc {
        pretty-print($_, :level($level), :$ws, :$desc ) for $struct.flat.sort.reverse.List
    } else {
        pretty-print($_, :level($level), :$ws, :$desc ) for $struct.flat.sort.List
    }
}

multi pretty-print (Pair $struct, :$level = 0, :$ws = '    ', :$desc = False) {
    say $ws x $level, $struct.key;
    pretty-print( $struct.value.sort( ).List, :level($level + 1), :$ws, :$desc )
}

multi pretty-print (Str $struct, :$level = 0, :$ws = '    ', :$desc = False) {
    say $ws x $level , $struct;
}
