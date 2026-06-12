def count(s): reduce s as $x (0; .+1);

range(1;1000)
| select( tostring | explode | 2 == count( select(.[] == 49))) # "1"
