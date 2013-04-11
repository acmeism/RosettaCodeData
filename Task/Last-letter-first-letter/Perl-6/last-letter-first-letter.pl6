my @names = <
    audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
    cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
    girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
    kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
    nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
    porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
    sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
    tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask
>;

my @last = @names.map: {.substr(*-1,1).ord }
my @succs = [] xx 128;
for @names.kv -> $i, $name {
    my $ix = $name.ord; # $name.substr(0,1).ord
    push @succs[$ix], $i;
}

my $OUT = open "llfl.new", :w or die "Can't create llfl.new: $!";
$OUT.print: chr($_ + 32),"\n" for 0 ..^ @names;
close $OUT;
my $new = +@names;
my $len = 1;

while $new {
    say "Length { $len++ }: $new candidates";
    shell 'mv llfl.new llfl.known';
    my $IN = open "llfl.known" or die "Can't reopen llfl.known: $!";
    my $OUT = open "llfl.new", :w or die "Can't create llfl.new: $!";
    $new = 0;

    loop {
	my $cand = $IN.get // last;
	for @succs[@last[$cand.ord - 32]][] -> $i {
	    my $ic = chr($i + 32);
	    next if $cand ~~ /$ic/;
	    $OUT.print: $ic,$cand,"\n";
	    $new++;
	}
    }
    $IN.close;
    $OUT.close;
}

my $IN = open "llfl.known" or die "Can't reopen llfl.known: $!";
my $eg = $IN.lines.pick;
say "Length of longest: ", $eg.chars;
say join ' ', $eg.ords.reverse.map: { @names[$_ - 32] }
