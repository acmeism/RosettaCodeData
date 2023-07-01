class BT {
    has @.coeff;

    my %co2bt = '-1' => '-', '0' => '0', '1' => '+';
    my %bt2co = %co2bt.invert;

    multi method new (Str $s) {
	self.bless(coeff => %bt2co{$s.flip.comb});
    }
    multi method new (Int $i where $i >= 0) {
	self.bless(coeff => carry $i.base(3).comb.reverse);
    }
    multi method new (Int $i where $i < 0) {
	self.new(-$i).neg;
    }

    method Str () { %co2bt{@!coeff}.join.flip }
    method Int () { [+] @!coeff Z* (1,3,9...*) }

    multi method neg () {
	self.new: coeff => carry self.coeff X* -1;
    }
}

sub carry (*@digits is copy) {
    loop (my $i = 0; $i < @digits; $i++) {
	while @digits[$i] < -1 { @digits[$i] += 3; @digits[$i+1]--; }
	while @digits[$i] > 1  { @digits[$i] -= 3; @digits[$i+1]++; }
    }
    pop @digits while @digits and not @digits[*-1];
    @digits;
}

multi prefix:<-> (BT $x) { $x.neg }

multi infix:<+> (BT $x, BT $y) {
    my ($b,$a) = sort +*.coeff, ($x, $y);
    BT.new: coeff => carry ($a.coeff Z+ |$b.coeff, |(0 xx $a.coeff - $b.coeff));
}

multi infix:<-> (BT $x, BT $y) { $x + $y.neg }

multi infix:<*> (BT $x, BT $y) {
    my @x = $x.coeff;
    my @y = $y.coeff;
    my @z = 0 xx @x+@y-1;
    my @safe;
    for @x -> $xd {
	@z = @z Z+ |(@y X* $xd), |(0 xx @z-@y);
	@safe.push: @z.shift;
    }
    BT.new: coeff => carry @safe, @z;
}

my $a = BT.new: "+-0++0+";
my $b = BT.new: -436;
my $c = BT.new: "+-++-";
my $x = $a * ( $b - $c );

say 'a == ', $a.Int;
say 'b == ', $b.Int;
say 'c == ', $c.Int;
say "a × (b − c) == ", ~$x, ' == ', $x.Int;
