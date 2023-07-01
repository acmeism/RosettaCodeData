use feature 'say';
use ntheory qw/forsetproduct/;

# Deconvolution of N dimensional matrices
sub deconvolve_N {
    our @g; local *g = shift;
    our @f; local *f = shift;
    my @df = shape(@f);
    my @dg = shape(@g);
    my @hsize;
    push @hsize, $dg[$_] - $df[$_] + 1 for 0..$#df;
    my @toSolve = map { [row(\@g, \@f, \@hsize, $_)] } coords(shape(@g));
    rref( \@toSolve );

    my @h;
    my $n = 0;
    for (coords(@hsize)) {
        my($k,$j,$i) = split ' ', $_;
        $h[$i][$j][$k] = $toSolve[$n++][-1];
    }
    @h;
}

sub row {
    our @g;      local *g      = shift;
    our @f;      local *f      = shift;
    our @hsize;  local *hsize  = shift;
    my @gc = reverse split ' ', shift;

    my @row;
    my @fdim = shape(@f);
    for (coords(@hsize)) {
        my @hc = reverse split ' ', $_;
        my @fc;
        for my $i (0..$#hc) {
            my $window = $gc[$i] - $hc[$i];
            push(@fc, $window), next if 0 <= $window && $window < $fdim[$i];
        }
        push @row, $#fc == $#hc ? $f [$fc[0]] [$fc[1]] [$fc[2]] : 0;
    }
    push @row, $g [$gc[0]] [$gc[1]] [$gc[2]];
    return @row;
}

sub rref {
  our @m; local *m = shift;
  @m or return;
  my ($lead, $rows, $cols) = (0, scalar(@m), scalar(@{$m[0]}));

  foreach my $r (0 .. $rows - 1) {
     $lead < $cols or return;
      my $i = $r;

      until ($m[$i][$lead])
         {++$i == $rows or next;
          $i = $r;
          ++$lead == $cols and return;}

      @m[$i, $r] = @m[$r, $i];
      my $lv = $m[$r][$lead];
      $_ /= $lv foreach @{ $m[$r] };

      my @mr = @{ $m[$r] };
      foreach my $i (0 .. $rows - 1)
         {$i == $r and next;
          ($lv, my $n) = ($m[$i][$lead], -1);
          $_ -= $lv * $mr[++$n] foreach @{ $m[$i] };}

      ++$lead;}
}

# Constructs an AoA of coordinates to all elements of N dimensional array
sub coords {
    my(@dimensions) = reverse @_;
    my(@ranges,@coords);
    push @ranges, [0..$_-1] for @dimensions;
    forsetproduct { push @coords, "@_" } @ranges;
    @coords;
}

sub shape {
    my(@dim);
    push @dim, scalar @_;
    push @dim, shape(@{$_[0]}) if 'ARRAY' eq ref $_[0];
    @dim;
}

# Pretty printer for N dimensional arrays
# Assumes if first element in level is an array, then all are
sub pretty_print {
    my($i, @a) = @_;
    if ('ARRAY' eq ref $a[0]) {
        say ' 'x$i, '[';
        pretty_print($i+2, @$_) for @a;
        say ' 'x$i, ']', $i ? ',' : '';
    } else {
        say ' 'x$i, '[', sprintf("@{['%5s'x@a]}",@a), ']', $i ? ',' : '';
    }
}

my @f = (
  [
    [ -9,  5, -8 ],
    [  3,  5,  1 ],
  ],
  [
    [ -1, -7,  2 ],
    [ -5, -6,  6 ],
  ],
  [
    [  8,  5,  8 ],
    [ -2, -6, -4 ],
  ]
);

my @g = (
  [
    [  54,  42,  53, -42,  85, -72 ],
    [  45,-170,  94, -36,  48,  73 ],
    [ -39,  65,-112, -16, -78, -72 ],
    [   6, -11,  -6,  62,  49,   8 ],
  ],
  [
    [ -57,  49, -23,  52,-135,  66 ],
    [ -23, 127, -58,  -5,-118,  64 ],
    [  87, -16, 121,  23, -41, -12 ],
    [ -19,  29,  35,-148, -11,  45 ],
  ],
  [
    [ -55,-147,-146, -31,  55,  60 ],
    [ -88, -45, -28,  46, -26,-144 ],
    [ -12,-107, -34, 150, 249,  66 ],
    [  11, -15, -34,  27, -78, -50 ],
  ],
  [
    [  56,  67, 108,   4,   2, -48 ],
    [  58,  67,  89,  32,  32,  -8 ],
    [ -42, -31,-103, -30, -23,  -8 ],
    [   6,   4, -26, -10,  26,  12 ],
  ]
);

my @h  = deconvolve_N( \@g, \@f );
my @ff = deconvolve_N( \@g, \@h );

my $d = scalar shape(@g);
print "${d}D arrays:\n";
print "h =\n";
pretty_print(0,@h);
print "\nff =\n";
pretty_print(0,@ff);
