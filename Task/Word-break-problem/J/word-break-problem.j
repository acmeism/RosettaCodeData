all_partitions=: <@(<;.1)"1 _~  (1,.[:#:[:i.2^<:@:#)  NB. all_partitions 'abcd'
word_break=: ([ #~ 0 = [: #&>@:] -.L:_1 _)~ all_partitions
main=: (] , (;:inv L:_1@:word_break >))"_ 0 boxopen
