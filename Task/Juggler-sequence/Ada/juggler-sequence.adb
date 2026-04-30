with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Juggler is

   subtype Number  is Long_Long_Integer;
   type Index_Type is new Natural;

   subtype Initial_Values is Number range 20 .. 39;

   generic
      Initial : Number;
   package Generic_Juggler is
      procedure Next (Value : out Number; Index : out Index_Type);
   end Generic_Juggler;

   package body Generic_Juggler is

      type Real is new Long_Long_Float;

      package Real_Math is
        new Ada.Numerics.Generic_Elementary_Functions (Real);

      K   : Index_Type := 0;
      A_K : Real       := Real (Initial);

      procedure Next (Value : out Number; Index : out Index_Type) is
         use Real_Math;
      begin
         Value := Number (A_K);
         Index := K;
         A_K := (if Number (A_K) mod 2 = 0
                 then Real'Floor (A_K ** 0.5)
                 else Real'Floor (A_K ** 1.5));
         K := K + 1;
      end Next;

   end Generic_Juggler;

   procedure Statistics (N   : Number;     L_N : out Index_Type;
                         H_N : out Number; I_N : out Index_Type)
   is
      package Juggler_Generator is new Generic_Juggler (Initial => N);
      use Juggler_Generator;
      Value : Number;
   begin
      H_N := 0;
      I_N := 0;
      loop
         Next (Value, L_N);
         if Value > H_N then
            H_N := Value;
            I_N := L_N;
         end if;
         exit when Value = 1;
      end loop;
   end Statistics;

   procedure Put_Table is
      package Number_IO is new Ada.Text_IO.Integer_IO (Number);
      package Index_IO  is new Ada.Text_IO.Integer_IO (Index_Type);
      use Ada.Text_IO, Number_IO, Index_IO;
      L_N : Index_Type;
      H_N : Number;
      I_N : Index_Type;
   begin
      Put_Line ("  N   L(N)            H(N)   I(N)");
      Put_Line ("---------------------------------");
      for N in Initial_Values loop
         Statistics (N, L_N, H_N, I_N);
         Put (N, Width => 3);     Put (L_N, Width => 7);
         Put (H_N, Width => 16);  Put (I_N, Width => 7);  New_Line;
      end loop;
   end Put_Table;

begin
   Put_Table;
end Juggler;
