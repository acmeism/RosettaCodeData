import: console

: reversalGame
| l n |
   doWhile: [		
      ListBuffer new ->l
      while(l size 9 <>) [ 9 rand dup l include ifFalse: [ l add ] else: [ drop ] ]
      l sort l ==
      ]

   0 while(l sort l <>) [
      System.Out "List is " << l << " ==> how many digits from left to reverse : " <-
      System.Console askln asInteger dup ifNull: [ drop continue ] ->n
      1+ l left(n) reverse l right(l size n -) + ->l
      ]
   "You won ! Your score is :" . println ;
