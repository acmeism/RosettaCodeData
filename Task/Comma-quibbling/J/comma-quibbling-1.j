quibLast2=: ' and ' joinstring (2 -@<. #) {. ]
withoutLast2=: ([: # _2&}.) {. ]
quibble=: '{', '}' ,~ ', ' joinstring withoutLast2 , <@quibLast2
