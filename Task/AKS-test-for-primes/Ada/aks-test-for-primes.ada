with Ada.Text_IO;

procedure Test_For_Primes is

   type Pascal_Triangle_Type is array (Natural range <>) of Long_Long_Integer;

   function Calculate_Pascal_Triangle (N : in Natural) return Pascal_Triangle_Type is
      Pascal_Triangle : Pascal_Triangle_Type (0 .. N);
   begin
      Pascal_Triangle (0) := 1;
      for I in Pascal_Triangle'First .. Pascal_Triangle'Last - 1 loop
         Pascal_Triangle (1 + I) := 1;
         for J in reverse 1 .. I loop
            Pascal_Triangle (J) := Pascal_Triangle (J - 1) - Pascal_Triangle (J);
         end loop;
         Pascal_Triangle (0) := -Pascal_Triangle (0);
      end loop;
      return Pascal_Triangle;
   end Calculate_Pascal_Triangle;

   function Is_Prime (N : Integer) return Boolean is
      I      : Integer;
      Result : Boolean := True;
      Pascal_Triangle : constant Pascal_Triangle_Type := Calculate_Pascal_Triangle (N);
   begin
      I := N / 2;
      while Result and I > 1 loop
         Result := Result and Pascal_Triangle (I) mod Long_Long_Integer (N) = 0;
         I := I - 1;
      end loop;
      return Result;
   end Is_Prime;

   function Image (N    : in Long_Long_Integer;
                   Sign : in Boolean := False) return String is
      Image : constant String := N'Image;
   begin
      if N < 0 then
         return Image;
      else
         if Sign then
            return "+" & Image (Image'First + 1 .. Image'Last);
         else
            return Image (Image'First + 1 .. Image'Last);
         end if;
      end if;
   end Image;

   procedure Show (Triangle : in Pascal_Triangle_Type) is
      use Ada.Text_IO;
   Begin
      for I in reverse Triangle'Range loop
         Put (Image (Triangle (I), Sign => True));
         Put ("x^");
         Put (Image (Long_Long_Integer (I)));
         Put (" ");
      end loop;
   end Show;

   procedure Show_Pascal_Triangles is
      use Ada.Text_IO;
   begin
      for N in 0 .. 9 loop
         declare
            Pascal_Triangle : constant Pascal_Triangle_Type := Calculate_Pascal_Triangle (N);
         begin
            Put ("(x-1)^" & Image (Long_Long_Integer (N)) & " = ");
            Show (Pascal_Triangle);
            New_Line;
         end;
      end loop;
   end Show_Pascal_Triangles;

   procedure Show_Primes is
      use Ada.Text_IO;
   begin
      for N in 2 .. 63 loop
         if Is_Prime (N) then
            Put (N'Image);
         end if;
      end loop;
      New_Line;
   end Show_Primes;

begin
   Show_Pascal_Triangles;
   Show_Primes;
end Test_For_Primes;
