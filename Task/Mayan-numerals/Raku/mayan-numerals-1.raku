### Formatting ###
my $t-style = '"border-collapse: separate; text-align: center; border-spacing: 3px 0px;"';
my $c-style = '"border: solid black 2px;background-color: #fffff0;border-bottom: double 6px;'~
  'border-radius: 1em;-moz-border-radius: 1em;-webkit-border-radius: 1em;'~
  'vertical-align: bottom;width: 3.25em;"';
my $joiner = '<br>';

sub display ($num, @digits) { join "\n", "\{| style=$t-style", "|+ $num", '|-', (|@digits.map: {"| style=$c-style | $_"}), '|}' }

### Logic ###

sub mayan ($int) { $int.polymod(20 xx *).reverse.map: *.polymod(5) }

my @output = <4005 8017 326205 886205 16160025 1081439556 503491211079>.map: {
  display $_, .&mayan.map: { [flat '' xx 3, '●' x .[0], '───' xx .[1], ('Θ' if !.[0,1].sum)].tail(4).join: $joiner }
}

say @output.join: "\n$joiner\n";
