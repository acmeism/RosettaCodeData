# 20210220 Raku programming solution

sub propdiv (\x) {
   my @l = 1 if x > 1;
   (2 .. x.sqrt.floor).map: -> \d {
      unless x % d { @l.push: d; my \y = x div d; @l.push: y if y != d }
   }
   @l
}

sub sieve (\n) {
   my %s;
   for (0..(n+1)) -> \k {
      given ( [+] propdiv k ) { %s{$_} = True if $_ ≤ (n+1) }
   }
   %s;
}

my \limit = 1e5;
my %c = ( grep { !.is-prime }, 1..limit ).Set; # store composites
my %s = sieve(14 * limit);
my @untouchable = 2, 5;

loop ( my \n = $ = 6 ; n ≤ limit ; n += 2 ) {
   @untouchable.append(n) if (!%s{n} && %c{n-1} && %c{n-3})
}

my ($c, $last) = 0, False;
for @untouchable.rotor(10) {
   say [~] @_».&{$c++ ; $_ > 2000 ?? ( $last = True and last ) !! .fmt: "%6d "}
   $c-- and last if $last
}

say "\nList of untouchable numbers ≤ 2,000 : $c \n";

my ($p, $count) = 10,0;
BREAK: for @untouchable -> \n {
   $count++;
   if (n > $p) {
      printf "%6d untouchable numbers were found  ≤ %7d\n", $count-1, $p;
      last BREAK if limit == ($p *= 10)
   }
}
printf "%6d untouchable numbers were found  ≤ %7d\n", +@untouchable, limit
