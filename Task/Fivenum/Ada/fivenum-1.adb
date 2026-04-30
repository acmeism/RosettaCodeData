with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Generic_Array_Sort;

procedure Main is
   package Real_Io is new Float_IO (Long_Float);
   use Real_Io;

   type Data_Array is array (Natural range <>) of Long_Float;
   subtype Five_Num_Type is Data_Array (0 .. 4);

   procedure Sort is new Ada.Containers.Generic_Array_Sort
     (Index_Type => Natural, Element_Type => Long_Float,
      Array_Type => Data_Array);

   function Median (X : Data_Array) return Long_Float with
      Pre => X'Length > 0;

   function Median (X : Data_Array) return Long_Float is
      M : constant Natural := X'First + X'Last / 2;
   begin
      if X'Length rem 2 = 1 then
         return X (M);
      else
         return (X (M - 1) + X (M)) / 2.0;
      end if;
   end Median;

   procedure fivenum (X : Data_Array; Result : out Five_Num_Type) is
      Temp      : Data_Array := X;
      m         : Natural    := X'Length / 2;
      Lower_end : Natural    := (if X'Length rem 2 = 0 then m - 1 else m);
   begin
      Sort (Temp);
      Result (0) := Temp (Temp'First);
      Result (2) := Median (Temp);
      Result (4) := Temp (Temp'Last);
      Result (1) := Median (Temp (1 .. Lower_end));
      Result (3) := Median (Temp (m .. Temp'Last));
   end fivenum;

   procedure print (Result : Five_Num_Type; Aft : Natural) is
   begin
      Put ("[");
      for I in Result'Range loop
         Put (Item => Result (I), Fore => 1, Aft => Aft, Exp => 0);
         if I < Result'Last then
            Put (", ");
         else
            Put_Line ("]");
         end if;
      end loop;
      New_Line;
   end print;

   X1 : Data_Array :=
     (15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0);
   X2 : Data_Array := (36.0, 40.0, 7.0, 39.0, 41.0, 15.0);
   X3 : Data_Array :=
     (0.140_828_34, 0.097_487_90, 1.731_315_07, 0.876_360_09, -1.950_595_94,
      0.734_385_55, -0.030_357_26, 1.466_759_70, -0.746_213_49, -0.725_887_72,
      0.639_051_60, 0.615_015_27, -0.989_837_80, -1.004_478_74, -0.627_594_69,
      0.662_061_63, 1.043_120_09, -0.103_053_85, 0.757_756_34, 0.325_665_78);
   Result : Five_Num_Type;
begin
   fivenum (X1, Result);
   print (Result, 1);
   fivenum (X2, Result);
   print (Result, 1);
   fivenum (X3, Result);
   print (Result, 9);
end Main;
