use ntheory qw/chinese lcm/;
say chinese( [2328,16256], [410,5418] ), " mod ", lcm(16256,5418);
