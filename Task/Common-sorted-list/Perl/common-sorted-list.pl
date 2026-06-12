@c{@$_}++ for [5,1,3,8,9,4,8,7], [3,5,9,8,4], [1,3,7,9];
print join ' ', sort keys %c;
@c{@$_}++ for [qw<not all is integer ? is not ! 4.2>];
print join ' ', sort keys %c;
