with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;

with Ada.Containers.Generic_Array_Sort;

procedure Demo_Array_Sort is

   function "+" (S : String) return Unbounded_String renames To_Unbounded_String;

   type A_Composite is
      record
         Name  : Unbounded_String;
         Value : Unbounded_String;
      end record;

   function "<" (L, R : A_Composite) return Boolean is
   begin
      return L.Name < R.Name;
   end "<";

   procedure Put_Line (C : A_Composite) is
   begin
      Put_Line (To_String (C.Name) & " " & To_String (C.Value));
   end Put_Line;

   type An_Array is array (Natural range <>) of A_Composite;

   procedure Sort is new Ada.Containers.Generic_Array_Sort (Natural, A_Composite, An_Array);

   Data : An_Array := (1 => (Name => +"Joe",    Value => +"5531"),
                       2 => (Name => +"Adam",   Value => +"2341"),
                       3 => (Name => +"Bernie", Value => +"122"),
                       4 => (Name => +"Walter", Value => +"1234"),
                       5 => (Name => +"David",  Value => +"19"));

begin
   Sort (Data);
   for I in Data'Range loop
      Put_Line (Data (I));
   end loop;
end Demo_Array_Sort;
