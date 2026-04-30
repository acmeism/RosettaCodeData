with Ada.Containers.Doubly_Linked_Lists;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure List_Insertion is
   package String_List is new Ada.Containers.Doubly_Linked_Lists(Unbounded_String);
   use String_List;
   procedure Print(Position : Cursor) is
   begin
      Put_Line(To_String(Element(Position)));
   end Print;
   The_List : List;
begin
   The_List.Append(To_Unbounded_String("A"));
   The_List.Append(To_Unbounded_String("B"));
   The_List.Insert(Before => The_List.Find(To_Unbounded_String("B")),
      New_Item => To_Unbounded_String("C"));
   The_List.Iterate(Print'access);
end List_Insertion;
