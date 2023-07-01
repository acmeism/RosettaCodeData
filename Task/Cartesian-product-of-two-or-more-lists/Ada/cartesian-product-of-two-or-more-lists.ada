with Ada.Text_IO;  use Ada.Text_Io;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Strings.Fixed;

procedure Cartesian is

   type Element_Type is new Long_Integer;

   package Lists is
      new Ada.Containers.Doubly_Linked_Lists (Element_Type);
   package List_Lists is
      new Ada.Containers.Doubly_Linked_Lists (Lists.List, Lists."=");

   subtype List      is Lists.List;
   subtype List_List is List_Lists.List;

   function "*" (Left, Right : List) return List_List is
      Result : List_List;
      Sub    : List;
   begin
      for Outer of Left loop
         for Inner of Right loop
            Sub.Clear;
            Sub.Append (Outer);
            Sub.Append (Inner);
            Result.Append (Sub);
         end loop;
      end loop;
      return Result;
   end "*";

   function "*" (Left  : List_List;
                 Right : List) return List_List
   is
      Result : List_List;
      Sub    : List;
   begin
      for Outer of Left loop
         for Inner of Right loop
            Sub := Outer;
            Sub.Append (Inner);
            Result.Append (Sub);
         end loop;
      end loop;
      return Result;
   end "*";

   procedure Put (L : List) is
      use Ada.Strings;
      First : Boolean := True;
   begin
      Put ("(");
      for E of L loop
         if not First then
            Put (",");
         end if;
         Put (Fixed.Trim (E'Image, Left));
         First := False;
      end loop;
      Put (")");
   end Put;

   procedure Put (LL : List_List) is
      First : Boolean := True;
   begin
      Put ("{");
      for E of LL loop
         if not First then
            Put (",");
         end if;
         Put (E);
         First := False;
      end loop;
      Put ("}");
   end Put;

   function "&" (Left : List; Right : Element_Type) return List is
      Result : List := Left;
   begin
      Result.Append (Right);
      return Result;
   end "&";

   Nil        : List renames Lists.Empty_List;
   List_1_2   : constant List := Nil & 1 & 2;
   List_3_4   : constant List := Nil & 3 & 4;
   List_Empty : constant List := Nil;
   List_1_2_3 : constant List := Nil & 1 & 2 & 3;
begin
   Put (List_1_2 * List_3_4); New_Line;

   Put (List_3_4 * List_1_2); New_Line;

   Put (List_Empty * List_1_2); New_Line;

   Put (List_1_2 * List_Empty); New_Line;

   Put (List'(Nil & 1776 & 1789) * List'(Nil & 7 & 12) *
          List'(Nil & 4 & 14 & 23) * List'(Nil & 0 & 1)); New_Line;

   Put (List_1_2_3 * List'(Nil & 30) * List'(Nil & 500 & 100)); New_Line;

   Put (List_1_2_3 * List_Empty * List'(Nil & 500 & 100)); New_Line;
end Cartesian;
