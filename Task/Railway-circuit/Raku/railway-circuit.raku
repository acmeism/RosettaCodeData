#!/usr/bin/env raku

# 20200406 Raku programming solution

class 𝒫 { has ($.x, $.y) } # Point

multi infix:<⊞>(𝒫 \p, 𝒫 \q) { 𝒫.bless: x => p.x + q.x , y => p.y + q.y }
multi infix:<≈>(𝒫 \p, 𝒫 \q) { my $*TOLERANCE = .0001; p.x ≅ q.x and p.y ≅ q.y }

constant twelvesteps = (1..12).map: { 𝒫.new: x =>sin(π*$_/6), y=>cos(π*$_/6) };
constant foursteps   = (1..4).map:  { 𝒫.new: x =>sin(π*$_/2), y=>cos(π*$_/2) };

sub digits($n!, $base!, $pad=0) {
   my @output =  $n.base($base).comb.reverse;
   @output.append: 0 xx ($pad - +@output) if $pad > +@output;
   return @output
} # rough port of https://docs.julialang.org/en/v1/base/numbers/#Base.digits

sub addsymmetries(%infound, \turns) {
   my @allsym.push: | .&{ (0..^+@$_).map: -> $n {rotate @$_, $n} } for turns, -«turns;
   %infound{$_} = True for @allsym;
   return @allsym.max
}

sub isclosedpath(@turns, \straight, \start= 𝒫.bless: x => 0, y => 0) {
   return False unless ( @turns.sum % (straight ?? 4 !! 12) ) == 0;
   my ($angl, $point) = (0, start);
   for @turns -> $turn {
      $angl  += $turn;
      $point ⊞= straight ?? foursteps[$angl % 4] !! twelvesteps[$angl % 12];
   }
   return $point ≈ start;
}

sub allvalidcircuits(\N, \doPrint=False, \straight=False) {
   my ( @found, %infound );
   say "\nFor N of ",N," and ", straight ?? "straight" !! "curved", " track: ";
   for (straight ?? (0..^3**N) !! (0..^2**N)) -> \i {
      my @turns = straight ??
         digits(i,3,N).map: { $_ == 0 ??  0 !! ($_ == 1 ?? -1 !! 1) } !!
         digits(i,2,N).map: { $_ == 0 ?? -1 !! 1 } ;
      if isclosedpath(@turns, straight) && !(%infound{@turns.Str}:exists) {
         my \canon = addsymmetries(%infound, @turns);
         say canon if doPrint;
         @found.push: canon.Str;
      }
   }
   say "There are ", +@found, " unique valid circuits.";
   return @found
}

allvalidcircuits($_, $_ < 28) for 12, 16, 20;    # 12, 16 … 36
allvalidcircuits($_, $_ < 12, True) for 4, 6, 8; # 4, 6 … 16;
