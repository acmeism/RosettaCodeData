package body Generic_Ulam is

   subtype Index is Natural range 0 .. Size-1;
   subtype Number is Positive range 1 .. Size**2;

   function Cell(Row, Column: Index) return Number is
      -- outputs the number at the given position in the square
      -- taken from the Python solution
      X: Integer := Column - (Size-1)/2;
      Y: Integer := Row - Size/2;
      MX: Natural := abs(X);
      MY: Natural := abs(Y);
      L: Natural := 2 * Natural'Max(MX, MY);
      D: Integer;
   begin
      if Y >= X then
         D := 3 * L + X + Y;
      else
         D := L - X - Y;
      end if;
      return (L-1) ** 2 + D;
   end Cell;

   procedure Print_Spiral is
      N: Number;
   begin
      for R in Index'Range loop
         for C in Index'Range loop
            N := Cell(R, C);
            Put_String(Represent(N));
         end loop;
         New_Line;
      end loop;
   end Print_Spiral;

end Generic_Ulam;
