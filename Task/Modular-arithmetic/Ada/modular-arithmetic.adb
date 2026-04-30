with Ada.Text_IO;

procedure Modular_Demo is

   type Modul_13 is mod 13;

   function F (X : Modul_13) return Modul_13 is
   begin
      return X**100 + X + 1;
   end F;

   package Modul_13_IO is
      new Ada.Text_IO.Modular_IO (Modul_13);

   use Ada.Text_IO;
   use Modul_13_IO;
   X_Integer  : constant Integer  := 10;
   X_Modul_13 : constant Modul_13 := Modul_13'Mod (X_Integer);
   F_10       : constant Modul_13 := F (X_Modul_13);
begin
   Put ("f("); Put (X_Modul_13); Put (" mod "); Put (Modul_13'Modulus'Image); Put (") = ");
   Put (F_10); Put (" mod ");    Put (Modul_13'Modulus'Image);
   New_Line;
end Modular_Demo;
