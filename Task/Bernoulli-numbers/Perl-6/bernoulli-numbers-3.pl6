sub infix:<bop>(\prev, \this) {
    this.key => this.key * (this.value - prev.value)
}

sub next-bernoulli ( (:key($pm), :value(@pa)) ) {
    $pm + 1 => [
        map *.value,
        [\bop] ($pm + 2 ... 1) Z=> FatRat.new(1, $pm + 2), |@pa
    ]
}

constant bernoulli =
    grep *.value,
    map { .key => .value[*-1] },
    (0 => [FatRat.new(1,1)], &next-bernoulli ... *)
;

constant @bpairs = bernoulli[^52];

my $width = [max] @bpairs.map: *.value.numerator.chars;
my $form = "B(%d)\t= \%{$width}d/%d\n";

printf $form, .key, .value.nude for @bpairs;
