with Ada.Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers;

procedure Names_Of_God is

   NN         : constant := 100_000;
   Row_Count  : constant := 25;
   Max_Column : constant := 79;

   package Triangle is
      procedure Print;
   end Triangle;

   package Row_Summer is
      procedure Calc (N : Integer);
      procedure Put_Sums;
   end Row_Summer;

   package body Row_Summer is
      use Ada.Text_IO;
      use Ada.Numerics.Big_Numbers.Big_Integers;

      P : array (0 .. NN + 1) of Big_Integer := (1, others => 0);

      procedure Calc (N : Integer) is
      begin
         P (N) := 0;

         for K in 1 .. N + 1 loop
            declare
               Add : constant Boolean := K mod 2 /= 0;
               D_1 : constant Integer := N - K * (3 * K - 1) / 2;
               D_2 : constant Integer := D_1 - K;
            begin
               exit when D_1 < 0;

               if Add
               then P (N) := P (N) + P (D_1);
               else P (N) := P (N) - P (D_1);
               end if;

               exit when D_2 < 0;

               if Add
               then P (N) := P (N) + P (D_2);
               else P (N) := P (N) - P (D_2);
               end if;
            end;
         end loop;
      end Calc;

      procedure Put_Wrapped (Item : Big_Integer) is
         Image : constant String := To_String (Item);
      begin
         Set_Col (11);
         for I in Image'Range loop
            if Ada.Text_IO.Col >= Max_Column then
               Set_Col (12);
            end if;
            Put (Image (I));
         end loop;
      end Put_Wrapped;

      procedure Put_Sums
      is
         package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);

         Printout : constant array (Natural range <>) of Integer :=
           (23, 123, 1234, 12_345, 20_000, 30_000, 40_000, 50_000, NN);

         Next : Natural := Printout'First;
      begin
         for A in 1 .. Printout (Printout'Last) loop
            Calc (A);
            if A = Printout (Next) then
               Put ("G (");
               Integer_IO.Put (A, Width => 0);
               Put (")");
               Put_Wrapped (P (A));
               New_Line;
               Next := Next + 1;
            end if;
         end loop;
      end Put_Sums;

   end Row_Summer;

   package body Triangle is

      Triangle : array (0 .. Row_Count,
                        0 .. Row_Count) of Integer := (others => (others => 0));

      procedure Calculate is
      begin
         Triangle (1,1) := 1;
         Triangle (2,1) := 1;
         Triangle (2,2) := 1;
         Triangle (3,1) := 1;
         Triangle (3,2) := 1;
         Triangle (3,3) := 1;
         for Row in 4 .. Row_Count loop
            for Col in 1 .. Row loop
               if Col * 2 > Row then
                  Triangle (Row, Col) := Triangle (Row - 1, Col - 1);
               else
                  Triangle (Row, Col) :=
                    Triangle (Row - 1, Col - 1) +
                    Triangle (Row - Col, Col);
               end if;
            end loop;
         end loop;
      end Calculate;

      procedure Print
      is
         use Ada.Text_IO;
         Width : array (1 .. Row_Count) of Natural := (others => 0);
      begin
         for Row in 1 .. Row_count loop
            for Col in 1 .. Row loop
               Width (Row) := Width (Row) + Triangle (Row, Col)'Image'Length;
            end loop;
         end loop;

         for Row in 1 .. Row_Count loop
            Set_Col (1 + Positive_Count (1 + Width (Width'Last)
                                           - Width (Row)) / 2);
            for Col in 1 .. Row loop
               Put (Triangle (Row, Col)'Image);
            end loop;
            New_Line;
         end loop;
      end Print;

   begin
      Calculate;
   end Triangle;

begin
   Triangle.Print;
   Row_Summer.Put_Sums;
end Names_Of_God;
