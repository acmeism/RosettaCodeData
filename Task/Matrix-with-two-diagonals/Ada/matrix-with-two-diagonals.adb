with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line;

procedure Matrix_With_Diagonals is

   type Matrix_Type is array (Positive range <>, Positive range <>) of Character;

   function Matrix_X (Length : Natural) return Matrix_Type is
   begin
      return M : Matrix_Type (1 .. Length, 1 .. Length) do
         for Row in M'Range (1) loop
            for Col in M'Range (2) loop
               M (Row, Col) := (if
                                  Row = Col or else
                                  Row = M'Last (2) - (Col - M'First (1))
                                then '1' else '0');
            end loop;
         end loop;
      end return;
   end Matrix_X;

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
   Put (Matrix_X (Length => Natural'Value (Ada.Command_Line.Argument (1))));

exception
   when others =>
      Put_Line ("Usage: ./matrix_with_diagonals <side-length>");

end Matrix_With_Diagonals;
