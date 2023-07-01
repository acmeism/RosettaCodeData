use List::MoreUtils qw(first_index);

$index1 = first_index { $_->{name} eq 'Dar Es Salaam' } @cities;
