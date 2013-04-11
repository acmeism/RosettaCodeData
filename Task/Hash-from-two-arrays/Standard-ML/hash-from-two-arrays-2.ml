exception NotFound;

val keys = [ "foo", "bar", "baz" ]
and vals = [ 16384, 32768, 65536 ]
and hash = HashTable.mkTable (HashString.hashString, op=) (42, NotFound);

ListPair.appEq (HashTable.insert hash) (keys, vals);
