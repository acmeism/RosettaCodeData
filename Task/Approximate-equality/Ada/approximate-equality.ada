with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Main is
   type Real is digits 18;
   package Real_Funcs is new Ada.Numerics.Generic_Elementary_Functions(Real);
   use Real_Funcs;
   package Real_IO is new Ada.Text_IO.Float_IO(Real);
   use Real_IO;

   function Approx_Equal (Left : Real; Right : Real) return Boolean is

      -- Calculate an epsilon value based upon the magnitude of the
      -- maximum value of the two parameters
      eps : Real := Real'Max(Left, Right) * 1.0e-9;
   begin
      if left > Right then
         return Left - Right < eps;
      else
         return Right - Left < eps;
      end if;
   end Approx_Equal;

   Type Index is (Left, Right);
   type Pairs_List is array (Index) of Real;
   type Pairs_Table is array(1..8) of Pairs_List;
   Table : Pairs_Table;

begin
   Table := ((100000000000000.01,   100000000000000.011),
             (100.01,   100.011),
             (10000000000000.001 / 10000.0,   1000000000.0000001000),
             (0.001,   0.0010000001),
             (0.000000000000000000000101,   0.0),
             (sqrt(2.0) * sqrt(2.0),    2.0),
             (-sqrt(2.0) * sqrt(2.0),   -2.0),
             (3.14159265358979323846,   3.14159265358979324));

   for Pair of Table loop
      Put(Item => Pair(Left), Exp => 0, Aft => 16, Fore => 6);
      Put("  ");
      Put(Item => Pair(Right), Exp => 0, Aft => 16, Fore => 6);
      Put_Line("  " & Boolean'Image(Approx_Equal(Pair(Left), Pair(Right))));
   end loop;

end Main;
