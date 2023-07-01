include lib/hash.4th
include lib/hashkey.4th

\ Create a hash table 'table' with a starting size of 10

['] fnv1a is hash                      \ set hash method
10 constant /htable                    \ determine the size
/htable array htable                   \ allocate the table
latest /htable hashtable               \ turn it into a hashtable

\ Insert entries

 5 s" foo" htable put
10 s" bar" htable put
15 s" baz" htable put

\ Get entry from the table

s" bar" htable get error? if
  .( Entry not present.) cr drop
else
  .( Value: ) . cr
then
