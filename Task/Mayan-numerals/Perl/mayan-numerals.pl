use ntheory qw/fromdigits todigitstring/;

my $t_style = '"border-collapse: separate; text-align: center; border-spacing: 3px 0px;"';
my $c_style = '"border: solid black 2px;background-color: #fffff0;border-bottom: double 6px;'.
  'border-radius: 1em;-moz-border-radius: 1em;-webkit-border-radius: 1em;'.
  'vertical-align: bottom;width: 3.25em;"';

sub cartouches {
    my($num, @digits) = @_;
    my $render;
    for my $d (@digits) {
        $render .= "| style=$c_style | $_\n" for glyphs(@$d);
    }
    chomp $render;
    join "\n", "\{| style=$t_style", "|+ $num", '|-', $render, '|}'
}

sub glyphs {
    return 'Θ' unless $_[0] || $_[1];
    join '<br>', '●' x $_[0], ('───') x $_[1];
}

sub mmod {
    my($n,$b) = @_;
    my @nb;
    return 0 unless $n;
    push @nb, fromdigits($_, $b) for split '', todigitstring($n, $b);
    return @nb;
}

for $n (qw<4005 8017 326205 886205 26960840421>) {
    push @output, cartouches($n, map { [reverse mmod($_,5)] } mmod($n,20) );
}

print join "\n<br>\n", @output;
