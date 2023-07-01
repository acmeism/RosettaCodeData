USING: formatting io kernel qw sequences sorting ;

: .length ( str -- ) dup length "%u has length %d\n" printf ;

"I am a string" "I am a string too"
[ longer .length ] [ shorter .length ] 2bi nl

qw{ abcd 123456789 abcdef 1234567 } dup [ length ] inv-sort-with
"%u sorted by descending length:\n%u\n" printf
