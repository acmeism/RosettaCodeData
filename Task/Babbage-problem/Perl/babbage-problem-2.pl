# Dear Mr. Babbage,
# in the following code, $number is the variable to contain the number
# we're looking for. '%' is the modulo division operator and '!='
# means "not equal to".

# We start to search with 518, because no smaller number can be even
# squared to 269696. We also increment the number always by 2, as no
# odd number can be part of the solution. We do this, because
# computational power - even in 2022 - does not grow on trees.
# And even if it did, we have less of them than you did.

my $number = 518;
while ( ($number ** 2) % 1000000 != 269696 ) {
   $number += 2 ;
}
print "The square of $number is " . ($number ** 2) . " !\n";
