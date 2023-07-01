# 20220315 Raku programming solution

sub rare (\target where ( target > 0 and target ~~ Int )) {

   my \digit          = $ = 2;
   my $count          = 0;
   my @numeric_digits = 0..9 Z, 0 xx *;
   my @diffs1         = 0,1,4,5,6;

   # all possible digits pairs to calculate potential diffs
   my @pairs     = 0..9 X 0..9;
   my @all_diffs = -9..9;

   # lookup table for the first diff
   my @lookup_1 = [ [[2, 2], [8, 8]],    # Diff = 0
                    [[8, 7], [6, 5]],    # Diff = 1
                    [],
                    [],
                    [[4, 0],       ],    # Diff = 4
                    [[8, 3],       ],    # Diff = 5
                    [[6, 0], [8, 2]], ]; # Diff = 6

   # lookup table for all the remaining diffs
   given my %lookup_n { for @pairs -> \pair { $_{ [-] pair.values }.push: pair } }

   loop {
      my @powers = 10 <<**<< (0..digit-1); #  powers like 1, 10, 100, 1000....

      #  for n-r (aka L) the required terms, like 9/ 99 / 999 & 90 / 99999 & 9999 & 900 etc
      my @terms = (@powers.reverse Z- @powers).grep: * > 0 ;

      # create a cartesian product for all potential diff numbers
      # for the first use the very short one, for all other the complete 19 element
      my @diff_list = digit == 2 ?? @diffs1 !! [X] @diffs1, |(@all_diffs xx digit div 2 - 1);

      my @diff_list_iter = gather for @diff_list -> \k {
         # remove invalid first diff/second diff combinations
         { take k andthen next } if k.elems == 1 ;
         given (my (\a,\b) = k.values) {
            when a == 0 && b != 0                                    { next }
            when a == 1 && b ∉ [ -7, -5, -3, -1,  1, 3, 5, 7       ] { next }
            when a == 4 && b ∉ [ -8, -6, -4, -2,  0, 2, 4, 6, 8    ] { next }
            when a == 5 && b ∉ [ -3,  7                            ] { next }
            when a == 6 && b ∉ [ -9, -7, -5, -3, -1, 1, 3, 5, 7, 9 ] { next }
            default { take k }
         }
      }

      for @diff_list_iter -> \diffs {
         # calculate difference of original n and its reverse (aka L = n-r)
         # which must be a perfect square
         if (my \L = [+] diffs <<*>> @terms) > 0 and { $_ == $_.Int }(L.sqrt) {
            # potential candiate, at least L is a perfect square
            # placeholder for the digits
            my \dig = @ = 0 xx digit;

            # generate a cartesian product for each identified diff using the lookup tables
            my @c_iter = digit == 2
               ?? @lookup_1[diffs[0]].map: { [ $_ ] }
               !! [X] @lookup_1[diffs[0]], |(1..(+diffs + (digit % 2 - 1))).map: -> \k {
                  k == diffs ?? @numeric_digits !! %lookup_n{diffs[k]} }

            # check each H (n+r) by using digit combination
            for @c_iter -> \elt {
               for elt.kv -> \i, \pair { dig[i,digit-1-i] = pair.values }
               # for numbers with odd # digits restore the middle digit
               # which has been overwritten at the end of the previous cycle
               dig[(digit - 1) div 2] = elt[+elt - 1][0] if digit % 2 == 1 ;

	       my \rev = ( my \num = [~] dig ).flip;

               if num > rev and { $_ == $_.Int }((num+rev).sqrt) {
                  printf "%d: %12d reverse %d\n", $count+1, num, rev;
		  exit if ++$count == target;
               }
            }
         }
      }
      digit++
   }
}

my $N = 5;
say "The first $N rare numbers are,";
rare $N;
