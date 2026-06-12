# 20230601 Raku programming solution

sub toBern2 { [ @_[0], @_[0]+@_[1]/2, @_[0..2].sum ] }

sub toBern3 (@a) { @a[0], @a[0]+@a[1]/3, @a[0]+@a[1]*2/3+@a[2]/3, @a[0..3].sum }

sub evalBern-N (@b, $t) { # uses de Casteljau's algorithm
   my ($s, @bern) = 1 - $t, @b.Slip;
   while ( @bern.elems > 2 ) {
      @bern = @bern.rotor(2 => -1).map: { $s * .[0] + $t * .[1] };
   }
   return $s * @bern[0] + $t * @bern[1]
}

sub evaluations (@m, @b, $x) {
   my $m = ([o] map { $_ + $x * * }, @m)(0); # Horner's rule
   return "p({$x.fmt: '%.2f'}) = { evalBern-N @b, $x } (mono $m)";
}

sub bern2to3 (@a) { @a[0], @a[0]/3+@a[1]*2/3, @a[1]*2/3+@a[2]/3, @a[2] }

my (@pm,@qm,@rm) := ([1, 0, 0], [1, 2, 3], [1, 2, 3, 4]);

say "Subprogram(1) examples:";

my (@pb2,@qb2) := (@pm,@qm).map: { toBern2 $_ };
say "mono [{.[0]}] --> bern [{.[1]}]" for (@pm,@pb2,@qm,@qb2).rotor: 2;

say "\nSubprogram(2) examples:";

for (@pm,@pb2,@qm,@qb2).rotor(2) X (0.25,7.5) -> [[@m,@b], $x] {
   say evaluations @m, @b, $x
}

say "\nSubprogram(3) examples:";

.push(0) for (@pm,@qm);
my (@pb3,@qb3,@rb3) := (@pm,@qm,@rm).map: { toBern3 $_ };
say "mono [{.[0]}] --> bern [{.[1]}]" for (@pm,@pb3,@qm,@qb3,@rm,@rb3).rotor: 2;

say "\nSubprogram(4) examples:";

for (@pm,@pb3,@qm,@qb3,@rm,@rb3).rotor(2) X (0.25,7.5) -> [[@m,@b], $x] {
   say evaluations @m, @b, $x
}

say "\nSubprogram(5) examples:";

my (@pc,@qc) := (@pb2,@qb2).map: { bern2to3 $_ };
say  "mono [{.[1]}] --> bern [{.[0]}]" for (@pc,@pb2,@qc,@qb2).rotor: 2;
