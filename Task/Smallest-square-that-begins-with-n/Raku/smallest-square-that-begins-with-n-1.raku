# 20210319 Raku programming solution

my @needles  = (1..49);
my @haystack = (1..*) Z× (1..*);
# my @haystack = ( 1, 4, -> \a, \b { 2*b - a + 2 } ... * );
# my @haystack = ( 1, { (++$)² } ... * );
for @needles -> \needle {
   for @haystack -> \hay {
      { say needle, " => ", hay and last } if hay.starts-with: needle
   }
}
