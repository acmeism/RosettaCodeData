Object Class new: DNode(value, mutable prev, mutable next)

DNode method: initialize  := next := prev := value ;
DNode method: value  @value ;
DNode method: prev  @prev ;
DNode method: next  @next ;
DNode method: setPrev := prev ;
DNode method: setNext  := next ;
DNode method: <<  @value << ;

DNode method: insertAfter(node)
   node setPrev(self)
   node setNext(@next)
   @next ifNotNull: [ @next setPrev(node) ]
   node := next ;

// Double linked list definition
Collection Class new: DList(mutable head, mutable tail)
DList method: head  @head ;
DList method: tail  @tail ;

DList method: insertFront(v)
| p |
   @head ->p
   DNode new(v, null, p) := head
   p ifNotNull: [ p setPrev(@head) ]
   @tail ifNull: [ @head := tail ] ;

DList method: insertBack(v)
| n |
   @tail ->n
   DNode new(v, n, null) := tail
   n ifNotNull: [ n setNext(@tail) ]
   @head ifNull: [ @tail := head ] ;

DList method: forEachNext
   dup ifNull: [ drop @head ifNull: [ false ] else: [ @head @head true] return ]
   next dup ifNull: [ drop false ] else: [ dup true ] ;

DList method: forEachPrev
   dup ifNull: [ drop @tail ifNull: [ false ] else: [ @tail @tail true] return ]
   prev dup ifNull: [ drop false ] else: [ dup true ] ;

: test      // ( -- aDList )
| dl dn |
   DList new ->dl
   dl insertFront("A")
   dl insertBack("B")
   dl head insertAfter(DNode new("C", null , null))
   dl ;
