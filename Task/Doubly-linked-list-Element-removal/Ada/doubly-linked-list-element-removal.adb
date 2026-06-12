with Ada.Containers.Indefinite_Doubly_Linked_Lists;
with Ada.Text_Io;

procedure Element_Remove is

   package String_Lists is
     new Ada.Containers.Indefinite_Doubly_Linked_Lists
       (Element_Type => String);
   use String_Lists;

   procedure Print_List (List : String_Lists.List) is
      use Ada.Text_Io;
   begin
      for Element of List loop
         Put (Element); Put ("  ");
      end loop;
      New_Line;
   end Print_List;

   List : String_Lists.List;
   Cur  : String_Lists.Cursor;

begin
   List.Append ("cat");
   List.Append ("dog");
   List.Append ("hen");
   List.Append ("horse");

   Print_List (List);

   Cur := Find (List, "hen");
   List.Delete (Cur);

   Print_List (List);

end Element_Remove;
