generic
   type Element_Type is private;
package Linked_List is
   type List_Type is limited private;
...
private
   type List_Element;
   type List_Element_Ptr is access list_element;
   type List_Element is
      record
	 Prev : List_Element_Ptr;
	 Data : Element_Type;
	 Next : List_Element_Ptr;
      end record;
   type List_Type is
      record
	 Head        : List_Element_Ptr;     -- Pointer to first element.
	 Tail        : List_Element_Ptr;     -- Pointer to last element.
	 Cursor      : List_Element_Ptr;     -- Pointer to cursor element.
	 Count       : Natural := 0;         -- Number of items in list.
	 Traversing  : Boolean := False;     -- True when in a traversal.
      end record;
end Linked_List;
