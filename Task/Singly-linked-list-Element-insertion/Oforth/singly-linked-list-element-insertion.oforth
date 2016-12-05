Collection Class new: LinkedList(data, mutable next)

LinkedList method: initialize   := next := data ;
LinkedList method: data   @data ;
LinkedList method: next   @next ;
LinkedList method: add(e) e @next LinkedList new := next ;

LinkedList method: forEachNext
   dup ifNull: [ drop self ]
   dup 1 ifEq: [ drop false return ]
   dup next dup ifNull: [ drop 1 ]
   swap data true ;

: testLink  LinkedList new($A, null) dup add($B) dup add($C) ;

testLink println
