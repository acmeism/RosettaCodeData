@people = (['joe', 120], ['foo', 31], ['bar', 51]);
@people = sort { $a->[0] cmp $b->[0] } @people;
