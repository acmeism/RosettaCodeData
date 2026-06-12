# 20221021 Raku programming solution

sub countdown ($target, @numbers) {
   return False if @numbers.elems == 1;
   for @numbers.kv -> \n0k,\n0v {
      (my @nums1 = @numbers).splice(n0k,1);
      for @nums1.kv -> \n1k,\n1v {
         (my @nums2 = @nums1).splice(n1k,1);
         if n1v >= n0v {
            (my @numsNew = @nums2).append: my $res = n1v + n0v;
            if ($res == $target or countdown($target, @numsNew)) {
               say "$res = ",n1v,' + ',n0v andthen return True
            }
	        if n0v != 1 {
               (my @numsNew = @nums2).append: my $res = n1v * n0v;	
	           if ($res == $target or countdown($target, @numsNew)) {
                  say "$res = ",n1v,' * ',n0v andthen return True
	           }
            }
            if n1v != n0v {
	           (my @numsNew = @nums2).append: my $res = n1v - n0v;
	           if ($res == $target or countdown($target, @numsNew)) {
                  say "$res = ",n1v,' - ',n0v andthen return True
               }
            }
            if n0v != 1 and n1v %% n0v {
               (my @numsNew = @nums2).append: my $res = n1v div n0v;
               if ($res == $target or countdown($target, @numsNew)) {
                  say "$res = ",n1v,' / ',n0v andthen return True
               }
            }
         }
      }
   }
   return False
}

my @allNumbers  = < 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 25 50 75 100 >;
my @numbersList = <3 6 25 50 75 100>  ,   <100 75 50 25 6 3>,
                  <8 4 4 6 8 9>       ,   @allNumbers.pick(6);
my @targetList  = 952, 952, 594, (101..1000).pick;

for (0..^+@numbersList) -> \i {
   say "Using : ", my @numbers = |@numbersList[i];
   say "Target: ", my $target  = @targetList[i];
   say "No exact solution found" unless countdown $target, @numbers;
   say()
}
