with Ada.Text_Io;
with Ada.Command_Line;

procedure Four_Sides is

   type Matrix_Type is array (Natural range <>, Natural range <>) of Character;

   function Hollow (Length : Natural) return Matrix_Type is
   begin
      return M : Matrix_Type (1 .. Length, 1 .. Length) do
         for Row in M'Range(1) loop
            for Col in M'Range (2) loop
               M (Row, Col) := (if Row in M'First (1) | M'Last (1) or
                                  Col in M'First (2) | M'Last (2)
                                then '1' else '0');
            end loop;
         end loop;
      end return;
   end Hollow;

   procedure Put (M : Matrix_Type) is
   begin
      for Row in M'Range (1) loop
         for Col in M'Range (2) loop
            Ada.Text_Io.Put (" ");
            Ada.Text_Io.Put (M(Row,Col));
         end loop;
         Ada.Text_Io.New_Line;
      end loop;
   end Put;

begin
   Put (Hollow (Length => Natural'Value (Ada.Command_Line.Argument (1))));
exception
   when others =>
      Ada.Text_Io.Put_Line ("Usage: ./four_sides <length>");
end Four_Sides;
