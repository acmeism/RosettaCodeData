@people = (['joe', 120], ['foo', 31], ['bar', 51]);
@people = sort { $a->[1] <=> $b->[1] } @people;
