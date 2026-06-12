with Brent;
with Text_Io;
use Text_Io;
procedure Main is
   package Integer_Brent is new Brent(Element_Type => Integer);
   use Integer_Brent;
   function F (X : Integer) return Integer is
     ((X * X + 1) mod 255);
   type Mod255 is mod 255;
   package Mod255_Brent is new Brent(Element_Type => Mod255);
   function F255 (X : Mod255) return Mod255 is
      (X * X + 1);
   lambda : Integer;
   Mu : Integer;
   X : Integer := 3;
begin
   for I in 1..41 loop
      Put(Integer'Image(X));
      if I < 41 then
         Put(",");
      end if;
      X := F(X);
   end loop;
   New_Line;
   Integer_Brent.Brent(F'Access, 3, Lambda, Mu);
   Put_Line("Cycle Length: " & Integer'Image(Lambda));
   Put_Line("Start Index : " & Integer'Image(Mu));

   Mod255_Brent.Brent(F255'Access, 3, Lambda, Mu);
   Put_Line("Cycle Length: " & Integer'Image(Lambda));
   Put_Line("Start Index : " & Integer'Image(Mu));

   Put("Cycle       : ");
   X := 3;
   for I in 0..(Mu + Lambda) loop
      if Mu <= I and I < (Lambda + Mu) then
         Put(Integer'Image(X));
      end if;
      X := F(X);
   end loop;
end Main;
