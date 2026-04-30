with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;

with Ada.Containers.Ordered_Sets;

procedure Sort_Composites is

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

   package Composite_Sets is new Ada.Containers.Ordered_Sets (A_Composite);

   procedure Put_Line (C : Composite_Sets.Cursor) is
   begin
      Put_Line (Composite_Sets.Element (C));
   end Put_Line;

   Data : Composite_Sets.Set;

begin
   Data.Insert (New_Item => (Name => +"Joe",    Value => +"5531"));
   Data.Insert (New_Item => (Name => +"Adam",   Value => +"2341"));
   Data.Insert (New_Item => (Name => +"Bernie", Value => +"122"));
   Data.Insert (New_Item => (Name => +"Walter", Value => +"1234"));
   Data.Insert (New_Item => (Name => +"David",  Value => +"19"));
   Data.Iterate (Put_Line'Access);
end Sort_Composites;
