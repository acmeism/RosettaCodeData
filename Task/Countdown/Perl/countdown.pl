use v5.36;
use builtin 'indexed';
use experimental qw(builtin for_list);

sub countdown ($target, @numbers) {
   return 0 if 1 == scalar(@numbers);

   for my ($n0k,$n0v) (indexed @numbers) {
      my @nums1 = @numbers;
      splice(@nums1,$n0k,1);
      for my($n1k,$n1v) (indexed @nums1) {
         my @nums2 = @nums1;
         splice(@nums2,$n1k,1);
         my @numsNew;
         if ($n1v >= $n0v) {
            @numsNew = @nums2;
            push @numsNew, my $res = $n1v + $n0v;
            if ($res == $target or countdown($target, @numsNew)) {
               say "$res = $n1v + $n0v" and return 1
            }
            if ($n0v != 1) {
               @numsNew = @nums2;
               push @numsNew, my $res = $n1v * $n0v;
               if ($res == $target or countdown($target, @numsNew)) {
                  say "$res = $n1v * $n0v" and return 1
               }
            }
            if ($n1v != $n0v) {
               @numsNew = @nums2;
               push @numsNew, my $res = $n1v - $n0v;
               if ($res == $target or countdown($target, @numsNew)) {
                  say "$res = $n1v - $n0v" and return 1
               }
            }
            if ($n0v != 1 and 0==($n1v%$n0v)) {
               @numsNew = @nums2;
               push @numsNew, my $res = int($n1v / $n0v);
               if ($res == $target or countdown($target, @numsNew)) {
                   say "$res = $n1v / $n0v" and return 1
               }
            }
         }
      }
   }
   return 0
}

my @numbersList = ([3,6,25,50,75,100], [100,75,50,25,6,3], [8,4,4,6,8,9]);
my @targetList  =  <952                 952                 594>;

for my $i (0..2) {
   my $numbers = $numbersList[$i];
   say "Using : ", join ' ', @$numbers;
   say "Target: ", my $target  = $targetList[$i];
   say "No exact solution found" unless countdown($target, @$numbers);
   say '';
}
