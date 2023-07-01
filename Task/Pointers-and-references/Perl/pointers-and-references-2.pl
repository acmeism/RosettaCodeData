 # accessing the value
 print $$scalarref;     # 'aa'
 print @$arrayref;      # 'bbcc'
 print $arrayref->[1];  # 'cc'
 print $hashref->{ee};  # 'EE'

 # changing the value
 $$scalarref = 'a new string'; # changes $scalar
 $arrayref->[0] = 'foo';       # changes the first value of @array
 $hashref->{'dd'} = 'bar';     # changes the value with key 'dd' in %hash
