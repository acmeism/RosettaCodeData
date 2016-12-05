: longWords
| w longest l s |
   0 ->longest
   File new("unixdict.txt") forEach: w [
      w size dup ->s longest < ifTrue: [ continue ]
      w sort w == ifFalse: [ continue ]
      s longest > ifTrue: [ s ->longest ListBuffer new ->l ]
      l add(w)
      ] l ;
