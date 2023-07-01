with Ada.Text_IO;

procedure Sum_Of_Powers is

   type Base is range 0 .. 250; -- A, B, C, D and Y are in that range
   type Num is range 0 .. 4*(250**5); -- (A**5 + ... + D**5) is in that range
   subtype Fit is Num range 0 .. 250**5; -- Y**5 is in that range

   Modulus: constant Num := 254;
   type Modular is mod Modulus;

   type Result_Type is array(1..5) of Base; -- this will hold A,B,C,D and Y

   type Y_Type is array(Modular) of Base;
   type Y_Sum_Type is array(Modular) of Fit;

   Y_Sum: Y_Sum_Type := (others => 0);
   Y: Y_Type := (others => 0);
      -- for I in 0 .. 250, we set Y_Sum(I**5 mod Modulus) := I**5
      --                       and Y(I**5 mod Modulus) := I
      -- Modulus has been chosen to avoid collisions on (I**5 mod Modulus)
      -- later we will compute Sum_ABCD := A**5 + B**5 + C**5 + D**5
      -- and check if Y_Sum(Sum_ABCD mod modulus) = Sum_ABCD

   function Compute_Coefficients return Result_Type is

      Sum_A: Fit;
      Sum_AB, Sum_ABC, Sum_ABCD: Num;
      Short: Modular;

   begin
      for A in Base(0) .. 246 loop
         Sum_A := Num(A) ** 5;
         for B in A .. 247 loop
            Sum_AB := Sum_A + (Num(B) ** 5);
            for C in Base'Max(B,1) .. 248 loop -- if A=B=0 then skip C=0
               Sum_ABC := Sum_AB + (Num(C) ** 5);
               for D in C .. 249 loop
                  Sum_ABCD := Sum_ABC + (Num(D) ** 5);
                  Short    := Modular(Sum_ABCD mod Modulus);
                  if Y_Sum(Short) = Sum_ABCD then
                     return A & B & C & D & Y(Short);
                  end if;
               end loop;
            end loop;
         end loop;
      end loop;
      return 0 & 0 & 0 & 0 & 0;
   end Compute_Coefficients;

   Tmp: Fit;
   ABCD_Y: Result_Type;

begin -- main program

   -- initialize Y_Sum and Y
   for I in Base(0) .. 250 loop
      Tmp := Num(I)**5;
      if Y_Sum(Modular(Tmp mod Modulus)) /= 0 then
         raise Program_Error with "Collision: Change Modulus and recompile!";
      else
         Y_Sum(Modular(Tmp mod Modulus)) := Tmp;
         Y(Modular(Tmp mod Modulus)) := I;
      end if;
   end loop;

   -- search for a solution (A, B, C, D, Y)
   ABCD_Y := Compute_Coefficients;

   -- output result
   for Number of ABCD_Y loop
      Ada.Text_IO.Put(Base'Image(Number));
   end loop;
   Ada.Text_IO.New_Line;

end Sum_Of_Powers;
