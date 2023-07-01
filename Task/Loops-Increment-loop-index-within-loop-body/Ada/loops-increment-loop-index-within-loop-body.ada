with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO.Editing; use Ada.Text_IO.Editing;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Main is
   type nums is delta 0.1 digits 15;
   format : String  := "zz_zzz_zzz_zzz_zzz_zz9.9";
   pic    : picture := To_Picture (format);
   package Nums_io is new Decimal_Output (Nums);
   use Nums_IO;
   type U_64 is mod 2**64;

   package mod_io is new Modular_IO (U_64);
   use mod_io;

   function Is_Prime (Num : U_64) return boolean is
      package Flt_Funcs is new Ada.Numerics.Generic_Elementary_Functions
        (Float);
      use Flt_Funcs;

      T     : U_64          := 2;
      Limit : constant U_64 := U_64 (Sqrt (Float (Num)));
   begin
      if Num = 2 then
         return True;
      end if;
      while T <= Limit loop
         if Num mod T = 0 then
            return False;
         end if;
         T := T + (if T > 2 then 2 else 1);
      end loop;
      return True;
   end Is_Prime;
   Prime_Count : natural := 0;
   Prime_Test  : U_64    := 42;
begin
   loop
      if Is_Prime (Prime_Test) then
         Prime_Count := Prime_Count + 1;
         Put ("n =");
         Put (Item => Prime_Count, Width => 3);
         Put (Item => Nums (Prime_Test), Pic => pic);
         New_Line;
         Prime_Test := (Prime_Test * 2) - 1;
      end if;
      Prime_Test := Prime_Test + 1;
      exit when Prime_Count = 42;
   end loop;
end Main;
