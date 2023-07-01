with Ada.Text_Io;
with Ada.Numerics.Generic_Real_Arrays;

procedure Sum_Below_Diagonals is

   type Real is new Float;

   package Real_Arrays
   is new Ada.Numerics.Generic_Real_Arrays (Real);

   function Sum_Below_Diagonal (M : Real_Arrays.Real_Matrix) return Real
   with Pre => M'Length (1) = M'Length (2)
   is
      Sum : Real := 0.0;
   begin
      for Row in 0 .. M'Length (1) - 1 loop
         for Col in 0 .. Row - 1 loop
            Sum := Sum + M (M'First (1) + Row,
                            M'First (2) + Col);
         end loop;
      end loop;
      return Sum;
   end Sum_Below_Diagonal;

   M : constant Real_Arrays.Real_Matrix :=
     (( 1.0,  3.0,  7.0,  8.0, 10.0),
      ( 2.0,  4.0, 16.0, 14.0,  4.0),
      ( 3.0,  1.0,  9.0, 18.0, 11.0),
      (12.0, 14.0, 17.0, 18.0, 20.0),
      ( 7.0,  1.0,  3.0,  9.0,  5.0));
   Sum : constant Real := Sum_Below_Diagonal (M);

   package Real_Io is new Ada.Text_Io.Float_Io (Real);
   use Ada.Text_Io, Real_Io;
begin
   Put ("Sum below diagonal: ");
   Put (Sum, Exp => 0, Aft => 1);
   New_Line;
end Sum_Below_Diagonals;
