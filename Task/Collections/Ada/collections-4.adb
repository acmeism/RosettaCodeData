with Ada.Containers.Doubly_Linked_Lists;
use  Ada.Containers;

procedure Doubly_Linked_List is

   package DL_List_Pkg is new Doubly_Linked_Lists (Integer);
   use     DL_List_Pkg;

   DL_List : List;

begin

   DL_List.Append (1);
   DL_List.Append (2);
   DL_List.Append (3);

end Doubly_Linked_List;
