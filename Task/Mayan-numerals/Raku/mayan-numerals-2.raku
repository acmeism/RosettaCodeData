### Formatting ###
use Terminal::Boxer;
my $joiner = "\n";

sub display ($num, @digits) { "$num\n" ~ dd-box( :6cw, :4ch, @digits ) }

### Logic ###

sub mayan ($int) { $int.polymod(20 xx *).reverse.map: *.polymod(5) }

my @output = <4005 8017 326205 886205 16160025 1081439556 503491211079>.map: {
  display $_, .&mayan.map: { [flat '' xx 3, '●' x .[0], '────' xx .[1], ('Θ' if !.[0,1].sum)].tail(4).join: $joiner }
}

say @output.join: $joiner;
