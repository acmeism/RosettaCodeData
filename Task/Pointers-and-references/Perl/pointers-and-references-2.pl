 # printing the value
 print ${$scalar};
 print $arrayref->[1];          # this would print "array"
 print $hashref->{'secondkey'}; # this would print "hash"

 # changing the value
 ${$scalar} = 'a new string';       # would change $scalar as well
 $arrayref->[0] = 'an altered';     # would change the first value of @array as well
 $hashref->{'firstkey'} = 'a good'; # would change the value of the firstkey name value pair in %hash
