with Ada.Containers.Doubly_Linked_Lists;
with Ada.Text_IO;

procedure Deepcopy is
   package List is new Ada.Containers.Doubly_Linked_Lists (Integer);
   L1, L2 : List.List;
begin
   L1 := List.Empty_List;
   L1.Append (1);
   L1.Append (2);
   L2 := L1;
   L2.Append (3);

   Ada.Text_IO.Put_Line
     ("L1.Length = " & L1.Length'Image & " L2.Length = " & L2.Length'Image);
end Deepcopy;
