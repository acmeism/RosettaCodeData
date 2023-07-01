: test      // ( -- aDList )
| dl |
   DList new ->dl
   dl insertFront("A")
   dl insertBack("B")
   dl head insertAfter(DNode new("C", null , null))
   dl ;
