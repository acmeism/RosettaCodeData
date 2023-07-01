with Ada.Integer_Text_IO, Ada.Containers.Doubly_Linked_Lists;
use  Ada.Integer_Text_IO, Ada.Containers;

procedure Doubly_Linked_List is

   package DL_List_Pkg is new Doubly_Linked_Lists (Integer);
   use     DL_List_Pkg;

   procedure Print_Node (Position : Cursor) is
   begin
      Put (Element (Position));
   end Print_Node;

   DL_List : List;

begin

   DL_List.Append (1);
   DL_List.Append (2);
   DL_List.Append (3);

   -- Iterates through every node of the list.
   DL_List.Iterate (Print_Node'Access);

end Doubly_Linked_List;
