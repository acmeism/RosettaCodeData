: stringMatching(s1, s2)
| i |
   s2 isAllAt(s1, 1) ifTrue: [ System.Out s1 << " begins with " << s2 << cr ]
   s2 isAllAt(s1, s1 size s2 size - 1 + ) ifTrue: [ System.Out s1 << " ends with " << s2 << cr ]

   s1 indexOfAll(s2) ->i
   i ifNotNull: [ System.Out s1 << " includes " << s2 << " at position : " << i << cr ]

   "\nAll positions : " println
   1 ->i
   while (s1 indexOfAllFrom(s2, i) dup ->i notNull) [
      System.Out s1 << " includes " << s2 << " at position : " << i << cr
      i s2 size + ->i
      ] ;
