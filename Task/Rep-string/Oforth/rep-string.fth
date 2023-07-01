: repString(s)
| sz i |
   s size dup ->sz 2 / 1 -1 step: i [
      s left(sz i - ) s right(sz i -) == ifTrue: [ s left(i) return ]
      ]
   null ;
