sub array1 { return @{ [ 1, 2, 3 ] } }
sub  list1 { return qw{ 1 2 3 }      }

# both print '3', but why exactly?
say scalar array1();
say scalar  list1();

sub array2 { return @{ [ 3, 2, 1 ] } }
sub  list2 { return qw{ 3 2 1 }      }

say scalar array2(); # prints '3', number of elements in array
say scalar  list2(); # prints '1', last item in list
