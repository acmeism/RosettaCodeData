# 20201230 Raku programming solution

my @hourglasses = 4, 7;
my $target = 9;
my @output = [];
my %elapsed = 0 => 1 ;
my $done = False ;

for 1 .. ∞ -> $t {
   my $flip-happened = False;
   for @hourglasses -> $hg {
      unless $t % $hg {
         %elapsed{$t} = 1 unless %elapsed{$t};
         with @output[$t] { $_ ~= "\t, flip hourglass $hg " } else {
            $_ = "At time t = $t , flip hourglass $hg" }
         $flip-happened = True
      }
   }
   if $flip-happened {
      for %elapsed.keys.sort -> $t1 {
         if ($t - $t1) == $target {
            @output[$t1] ~= "\tbegin = 0";
            @output[$t]  ~= "\tend   = $target";
            $done = True
         }
         %elapsed{$t} = 1 unless %elapsed{$t} ;
      }
   }
   last if $done
}

.say if .defined for @output
