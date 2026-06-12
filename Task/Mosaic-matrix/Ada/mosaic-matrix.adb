with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line;

procedure Mosaic_Matrix is

   type Matrix_Type is array (Positive range <>, Positive range <>) of Character;

   function Mosaic (Length : Natural) return Matrix_Type is
   begin
      return M : Matrix_Type (1 .. Length, 1 .. Length) do
         for Row in M'Range (1) loop
            for Col in M'Range (2) loop
               M (Row, Col) := (if (Row + Col) mod 2 = 0
                                then '1' else '.');
            end loop;
         end loop;
      end return;
   end Mosaic;

   procedure Put (M : Matrix_Type) is
   begin
      for Row in M'Range (1) loop
         for Col in M'Range (2) loop
            Put (' ');
            Put (M (Row, Col));
         end loop;
         New_Line;
      end loop;
   end Put;

begin
   Put (Mosaic (Length => Natural'Value (Ada.Command_Line.Argument (1))));

exception
   when others =>
      Put_Line ("Usage: ./mosaic_matrix <side-length>");

end Mosaic_Matrix;
