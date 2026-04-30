with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Kronecker_Product is
   type Matrix is array (Positive range <>, Positive range <>) of Integer;

   function "*"(Left, Right : in Matrix) return Matrix is
      result : Matrix
        (1 .. Left'Length(1) * Right'Length(1),
         1 .. Left'Length(2) * Right'Length(2));
      LI : Natural := 0;
      LJ : Natural := 0;
   begin
      for I in 0 .. result'Length(1) - 1 loop
         for J in 0 .. result'Length(2) - 1 loop
            result (I + 1, J + 1) :=
              Left(Left'First(1) + (LI), Left'First(2) + (LJ))
              * Right
                (Right'First(1) + (I mod Right'Length(1)),
                 Right'First(2) + (J mod Right'Length(2)));
            if (J+1) mod Right'Length(2) = 0 then
               LJ := LJ + 1;
            end if;
         end loop;
         if (I+1) mod Right'Length(1) = 0 then
            LI := LI + 1;
         end if;
         LJ := 0;
      end loop;
      return result;
   end "*";

   Left1   : constant Matrix := ((1, 2), (3, 4));
   Right1  : constant Matrix := ((0, 5), (6, 7));
   result1 : constant Matrix := Left1 * Right1;
   Left2   : constant Matrix := ((0, 1, 0), (1, 1, 1), (0, 1, 0));
   Right2  : constant Matrix := ((1, 1, 1, 1), (1, 0, 0, 1), (1, 1, 1, 1));
   result2 : constant Matrix := Left2 * Right2;
begin
   for I in result1'Range(1) loop
      for J in result1'Range(2) loop
         Ada.Integer_Text_IO.Put(Ada.Text_IO.Standard_Output, result1(I, J));
      end loop;
      Ada.Text_IO.New_Line;
   end loop;

   Ada.Text_IO.New_Line;

   for I in result2'Range(1) loop
      for J in result2'Range(2) loop
         Ada.Integer_Text_IO.Put(Ada.Text_IO.Standard_Output, result2(I, J));
      end loop;
      Ada.Text_IO.New_Line;
   end loop;
end Kronecker_Product;
