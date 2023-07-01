with Ada.Containers.Generic_Array_Sort;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

procedure Sort_List_Identifiers is
   type Natural_Array is array (Positive range <>) of Natural;
   type Unbounded_String_Array is array(Positive range <>) of Unbounded_String;

   function To_Natural_Array(input : in String) return Natural_Array
   is
      target : Natural_Array(1 .. Ada.Strings.Fixed.Count(input, ".") + 1);
      from : Natural := input'First;
      to : Natural := Ada.Strings.Fixed.Index(input, ".");
      index : Positive := target'First;
   begin
      while to /= 0 loop
         target(index) := Natural'Value(input(from .. to - 1));
         from := to + 1;
         index := index + 1;
         to := Ada.Strings.Fixed.Index(input, ".", from);
      end loop;
      target(index) := Natural'Value(input(from .. input'Last));
      return target;
   end To_Natural_Array;

   function Lesser(Left, Right : in Unbounded_String) return Boolean is
   begin
      return To_Natural_Array(To_String(Left)) < To_Natural_Array(To_String(Right));
   end Lesser;

   procedure Sort is new Ada.Containers.Generic_Array_Sort
     (Index_Type   => Positive,
      Element_Type => Unbounded_String,
      Array_Type   => Unbounded_String_Array,
      "<"          => Lesser);

   table : Unbounded_String_Array :=
     (To_Unbounded_String("1.3.6.1.4.1.11.2.17.19.3.4.0.10"),
      To_Unbounded_String("1.3.6.1.4.1.11.2.17.5.2.0.79"),
      To_Unbounded_String("1.3.6.1.4.1.11.2.17.19.3.4.0.4"),
      To_Unbounded_String("1.3.6.1.4.1.11150.3.4.0.1"),
      To_Unbounded_String("1.3.6.1.4.1.11.2.17.19.3.4.0.1"),
      To_Unbounded_String("1.3.6.1.4.1.11150.3.4.0"));
begin
   Sort(table);
   for element of table loop
      Ada.Text_IO.Put_Line(To_String(element));
   end loop;
end Sort_List_Identifiers;
