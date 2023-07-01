structure StringMap = BinaryMapFn (struct
                                     type ord_key = string
                                     val compare = String.compare
                                   end);

val keys = [ "foo", "bar", "baz" ]
and vals = [ 16384, 32768, 65536 ]
and myMap = StringMap.empty;

val myMap = foldl StringMap.insert' myMap (ListPair.zipEq (keys, vals));
