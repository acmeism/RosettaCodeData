DList method: forEachNext
   dup ifNull: [ drop @head ifNull: [ false ] else: [ @head @head true] return ]
   next dup ifNull: [ drop false ] else: [ dup true ] ;

DList method: forEachPrev
   dup ifNull: [ drop @tail ifNull: [ false ] else: [ @tail @tail true] return ]
   prev dup ifNull: [ drop false ] else: [ dup true ] ;

: test
| dl n |
   DList new ->dl
   dl insertFront("A")
   dl insertBack("B")
   dl head insertAfter(DNode new("C", null , null))

   "Traversal (beginning to end) : " println
   dl forEach: n [ n . ]

   "\nTraversal (end to beginning) : " println
   dl revEach: n [ n . ] ;
