def summation(s): reduce s as $k (0; . + $k);

summation( range(1; 1001) | (1/(. * .) ) )
