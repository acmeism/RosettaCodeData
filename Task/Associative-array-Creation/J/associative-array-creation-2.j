   example=: conew 'assocArray'
   'foo' set__example 1 2 3
1 2 3
   'bar' set__example 4 5 6
4 5 6
   get__example 'foo'
1 2 3
   has__example 'foo'
1
   bletch__example=: 7 8 9
   get__example 'bletch'
7 8 9
   codestroy__example''
