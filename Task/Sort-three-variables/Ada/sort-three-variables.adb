with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Sort_Three is

   generic
      type Element_Type is private;
      with function "<" (Left, Right : in Element_Type) return Boolean;
   procedure Generic_Sort (X, Y, Z : in out Element_Type);

   procedure Generic_Sort (X, Y, Z : in out Element_Type)
   is
      procedure Swap (Left, Right : in out Element_Type) is
         T : constant Element_Type := Left;
      begin
         Left := Right;
         Right := T;
      end Swap;
   begin
      if Y < X then Swap (X, Y); end if;
      if Z < Y then Swap (Y, Z); end if;
      if Y < X then Swap (X, Y); end if;
   end Generic_Sort;

   procedure Test_Unbounded_Sort is
      use Ada.Text_IO;
      use Ada.Strings.Unbounded;

      X : Unbounded_String := To_Unbounded_String ("lions, tigers, and");
      Y : Unbounded_String := To_Unbounded_String ("bears, oh my!");
      Z : Unbounded_String := To_Unbounded_String ("(from the ""Wizard of OZ"")");

      procedure Sort is
         new Generic_Sort (Unbounded_String, "<");
   begin
      Sort (X, Y, Z);
      Put_Line (To_String (X));
      Put_Line (To_String (Y));
      Put_Line (To_String (Z));
      New_Line;
   End Test_Unbounded_Sort;

   procedure Test_Integer_Sort is

      use Ada.Text_IO;

      procedure Sort is
         new Generic_Sort (Integer, "<");

      X : Integer := 77444;
      Y : Integer :=   -12;
      Z : Integer :=     0;
   begin
      Sort (X, Y, Z);
      Put_Line (X'Image);
      Put_Line (Y'Image);
      Put_Line (Z'Image);
      New_Line;
   end Test_Integer_Sort;

begin
   Test_Unbounded_Sort;
   Test_Integer_Sort;
end Sort_Three;
