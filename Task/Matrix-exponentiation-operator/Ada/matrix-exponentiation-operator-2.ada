with Ada.Text_IO;                  use Ada.Text_IO;
with Ada.Complex_Text_IO;          use Ada.Complex_Text_IO;
with Ada.Numerics.Complex_Types;   use Ada.Numerics.Complex_Types;
with Ada.Numerics.Real_Arrays;     use Ada.Numerics.Real_Arrays;
with Ada.Numerics.Complex_Arrays;  use Ada.Numerics.Complex_Arrays;
with Ada.Numerics.Complex_Elementary_Functions; use Ada.Numerics.Complex_Elementary_Functions;

procedure Test_Matrix is
   function "**" (A : Complex_Matrix; Power : Complex) return Complex_Matrix is
      L  : Real_Vector (A'Range (1));
      X  : Complex_Matrix (A'Range (1), A'Range (2));
      R  : Complex_Matrix (A'Range (1), A'Range (2));
      RL : Complex_Vector (A'Range (1));
   begin
      Eigensystem (A, L, X);
      for I in L'Range loop
         RL (I) := (L (I), 0.0) ** Power;
      end loop;
      for I in R'Range (1) loop
         for J in R'Range (2) loop
            declare
               Sum : Complex := (0.0, 0.0);
            begin
               for K in RL'Range (1) loop
                  Sum := Sum + X (I, K) * RL (K) * X (J, K);
               end loop;
               R (I, J) := Sum;
            end;
         end loop;
      end loop;
      return R;
   end "**";
   procedure Put (A : Complex_Matrix) is
   begin
      for I in A'Range (1) loop
        for J in A'Range (2) loop
           Put (A (I, J));
        end loop;
        New_Line;
      end loop;
   end Put;
   M : Complex_Matrix (1..2, 1..2) := (((3.0,0.0),(2.0,1.0)),((2.0,-1.0),(1.0,0.0)));
begin
   Put_Line ("M =");      Put (M);
   Put_Line ("M**0 =");   Put (M**(0.0,0.0));
   Put_Line ("M**1 =");   Put (M**(1.0,0.0));
   Put_Line ("M**0.5 ="); Put (M**(0.5,0.0));
end Test_Matrix;
