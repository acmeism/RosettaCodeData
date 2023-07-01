# 20210218 Perl programming solution

use strict;
use warnings;

# create an integer object

print "Here is an integer             : ", my $target = 42, "\n";

# print the machine address of the object

print "And its reference is           : ", my $targetref = \$target, "\n";

# take the address of the object and create another integer object at this address

print "Now assigns a new value to it  : ", $$targetref = 69, "\n";

#  print the value of this object to verify that it is same as one of the origin

print "Then compare with the referent : ", $target, "\n";
