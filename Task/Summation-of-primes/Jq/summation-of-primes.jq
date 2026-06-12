def sum(s): reduce s as $x (0; .+$x);

sum(2, range(3 ; 2E6; 2) | select(is_prime))
