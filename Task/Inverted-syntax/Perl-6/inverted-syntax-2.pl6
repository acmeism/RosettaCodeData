while $i { --$i }
--$i while $i;

until $x > 10 { $x++ }
$x++ until $x > 10;

for 1..10 { .say if $_ %% 2 }
.say if $_ %% 2 for 1..10;  # list comprehension
