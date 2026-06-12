# 20230713 Raku programming solution

###### https://rosettacode.org/wiki/Number_names#Raku

constant @I = <zero one    two    three    four     five    six     seven     eight    nine
               ten  eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen>;
constant @X = <0    X      twenty thirty   forty    fifty   sixty   seventy   eighty   ninety>;
constant @C = @I X~ ' hundred';
constant @M = (<0 thousand>,
    ((<m b tr quadr quint sext sept oct non>,
    (map { ('', <un duo tre quattuor quin sex septen octo novem>).flat X~ $_ },
    <dec vigint trigint quadragint quinquagint sexagint septuagint octogint nonagint>),
    'cent').flat X~ 'illion')).flat;

sub int-name ($num) {
    if $num.substr(0,1) eq '-' { return "negative {int-name($num.substr(1))}" }
    if $num eq '0' { return @I[0] }
    my $m = 0;
    return join ', ', reverse gather for $num.flip.comb(/\d ** 1..3/) {
        my ($i,$x,$c) = .comb».Int;
        if $i or $x or $c {
            take join ' ', gather {
                if $c { take @C[$c] }
                if $x and $x == 1 { take @I[$i+10] }
                else {
                    if $x { take @X[$x] }
                    if $i { take @I[$i] }
                }
                take @M[$m] // die "WOW! ZILLIONS!\n" if $m;
            }
        }
        $m++;
    }
}
######

my ($i, $c, $limit, $prev, @nums, @lastDigs) = 0, 0, 1000, int-name(0);

while $limit <= 1e4 {
   my $next = int-name $i+1;
   if $prev.substr(*-1) eq $next.substr(0,1) {
      if ($c < 50) { @nums.append: $i };
      @lastDigs[$i % 10] += 1;
      $c++;
      if $c == 50 {
         say "First 50 numbers:";
         say [~] $_>>.fmt('%4s') for @nums.rotor(10);
         say();
      } elsif $c == $limit {
         print "The {$c}th number is $i.\n";
         say "Breakdown by last digit of first {$c}th numbers";
         say 'N Freq';
         for 0..9 -> $d {
            say "$d {@lastDigs[$d].fmt('%4s')} ",
                '█' x (@lastDigs[$d]/@lastDigs.max*72).Int;
         }
         say();
         $limit *= 10
      }
   }
   $prev = $next;
   $i++;
}
