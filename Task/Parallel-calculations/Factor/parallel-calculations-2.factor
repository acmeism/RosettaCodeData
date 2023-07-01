USING: kernel io prettyprint sequences arrays math.primes.factors math.parser concurrency.combinators ;
{ 576460752303423487 576460752303423487 576460752303423487 112272537195293
  115284584522153 115280098190773 115797840077099 112582718962171 }
dup [ factors ] parallel-map dup [ infimum ] map dup supremum
swap index swap dupd nth -rot swap nth
"Number with largest min. factor is " swap number>string append
", with factors: " append write .
