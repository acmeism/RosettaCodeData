unit sub MAIN(*@columns);

sub postfix:<!>($n) { [*] 1..$n }

say [+](@columns)! / [*](@columns»!);
