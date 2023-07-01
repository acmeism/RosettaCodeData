: semordnilap
| w wr wrds |
   ListBuffer new ->wrds
   ListBuffer new
   File new("unixdict.txt") forEach: w [
      wrds include(w reverse dup ->wr) ifTrue: [ [wr, w] over add ]
      w wr < ifTrue: [ wrds add(w) ]
      ] ;
