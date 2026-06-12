def count(s): reduce s as $x (null; .+1);
count(10 | generate(1))
