uses system ;

type

   // declare the list pointer type
   plist = ^List ;

   // declare the list type, a generic data pointer prev and next pointers
   List = record
      data : pointer ;
      next : pList ;
   end;

// since this task is just showing the traversal I am not allocating the memory and setting up the root node etc.
// Note the use of the carat symbol for de-referencing the pointer.

begin

   // beginning to end
   while not (pList^.Next = NIL) do pList := pList^.Next ;

end;
