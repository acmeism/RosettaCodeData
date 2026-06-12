USING: formatting math.primes.lucas-lehmer math.ranges sequences ;

: mersennes-upto ( n -- seq ) [1,b] [ lucas-lehmer ] filter ;

3500 mersennes-upto [ "2 ^ %d - 1\n" printf ] each
