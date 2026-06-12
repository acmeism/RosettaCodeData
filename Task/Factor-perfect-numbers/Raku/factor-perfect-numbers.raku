# 20221029 Raku programming solution

sub propdiv (\x) {
   my @l = 1 if x > 1;
   for (2 .. x.sqrt.floor) -> \d {
      unless x % d { @l.push: d; my \y = x div d; @l.push: y if y != d }
   }
   @l
}

sub moreMultiples (@toSeq, @fromSeq) {
   my @oneMores = gather for @fromSeq -> \j {
      take @toSeq.clone.push(j) if j > @toSeq[*-1] and j %% @toSeq[*-1]
   }
   return () unless @oneMores.Bool;
   for 0..^@oneMores {
      @oneMores.append: moreMultiples @oneMores[$_], @fromSeq
   }
   @oneMores
}

sub erdosFactorCount (\n) {
   state %cache;
   my ($sum,@divs) = 0, |(propdiv n)[1..*];
   for @divs -> \d {
      unless %cache{my \t = n div d}:exists { %cache{t} = erdosFactorCount(t) }
      $sum += %cache{t}
   }
   ++$sum
}

my @listing = moreMultiples [1], propdiv(48);
given @listing { $_.map: *.push: 48; $_.push: [1,48] }
say @listing.elems," sequences using first definition:";
for @listing.rotor(4) -> \line { line.map: { printf "%-20s", $_ } ; say() }

my @listing2 = gather for (0..^+@listing) -> \j {
   my @seq = |@listing[j];
   @seq.append: 48 if @seq[*-1] != 48;
   take (1..^@seq).map: { @seq[$_] div @seq[$_-1] }
}
say "\n{@listing2.elems} sequences using second definition:";
for @listing2.rotor(4) -> \line { line.map: { printf "%-20s", $_ } ; say() }

say "\nOEIS A163272:";
my ($n,@fpns) = 4, 0,1;
while (@fpns < 7) { @fpns.push($n) if erdosFactorCount($n) == $n; $n += 4 }
say ~@fpns;
