with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.Fixed;
with Interfaces; use Interfaces;

procedure Sieteri_Triangles is
   subtype Practical_Order is Unsigned_32 range 0..4;


   function Pow(X : Unsigned_32; N : Unsigned_32) return Unsigned_32 is
   begin
      if N = 0 then
         return 1;
      else
         return X * Pow(X, N - 1);
      end if;
   end Pow;

   procedure Print(Item : Unsigned_32) is
      use Ada.Strings.Fixed;
      package Ord_Io is new Ada.Text_Io.Modular_Io(Unsigned_32);
      use Ord_Io;
      Temp : String(1..36) := (others => ' ');
      First : Positive;
      Last  : Positive;
   begin
      Put(To => Temp, Item => Item, Base => 2);
      First := Index(Temp, "#") + 1;
      Last  := Index(Temp(First..Temp'Last), "#") - 1;
      for I in reverse First..Last loop
         if Temp(I) = '0' then
            Put(' ');
         else
            Put(Temp(I));
         end if;
      end loop;
      New_Line;
   end Print;

   procedure Sierpinski (N : Practical_Order) is
      Size : Unsigned_32 := Pow(2, N);
      V : Unsigned_32 := Pow(2, Size);
   begin
      for I in 0..Size - 1 loop
         Print(V);
         V := Shift_Left(V, 1) xor Shift_Right(V,1);
      end loop;
   end Sierpinski;

begin
   for N in Practical_Order loop
      Sierpinski(N);
   end loop;
end Sieteri_Triangles;
