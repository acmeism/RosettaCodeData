my $list2;

# create a new list ('A'. 'B', 'C') and store it in $list2
insert_after $list2 = { data => 'A' }, { data => 'B' }, { data => 'C' };

# append two new nodes ('D', 'E') after the first element
insert_after $list2, { data => 'A2' }, { data => 'A3' };

# append new nodes ('A2a', 'A2b') after the second element (which now is 'A2')
insert_after $list2->{next}, { data => 'A2a' }, { data => 'A2b' };
