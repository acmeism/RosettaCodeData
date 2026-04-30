with Ada.Text_IO;                  use Ada.Text_IO;
with Ada.Float_Text_IO;            use Ada.Float_Text_IO;
with Ada.Numerics.Real_Arrays;     use Ada.Numerics.Real_Arrays;

procedure Test_Matrix is
   procedure Put (A : Real_Matrix) is
   begin
      for I in A'Range (1) loop
        for J in A'Range (2) loop
           Put (" ");
           Put (A (I, J));
        end loop;
        New_Line;
      end loop;
   end Put;
   function "**" (A : Real_Matrix; Power : Integer) return Real_Matrix is
      L  : Real_Vector (A'Range (1));
      X  : Real_Matrix (A'Range (1), A'Range (2));
      R  : Real_Matrix (A'Range (1), A'Range (2));
      RL : Real_Vector (A'Range (1));
   begin
      Eigensystem (A, L, X);
      for I in L'Range loop
         RL (I) := L (I) ** Power;
      end loop;
      for I in R'Range (1) loop
         for J in R'Range (2) loop
            declare
               Sum : Float := 0.0;
            begin
               for K in RL'Range loop
                  Sum := Sum + X (I, K) * RL (K) * X (J, K);
               end loop;
               R (I, J) := Sum;
            end;
         end loop;
      end loop;
      return R;
   end "**";
   M : Real_Matrix (1..2, 1..2) := ((3.0, 2.0), (2.0, 1.0));
begin
   Put_Line ("M =");      Put (M);
   Put_Line ("M**0 =");   Put (M**0);
   Put_Line ("M**1 =");   Put (M**1);
   Put_Line ("M**2 =");   Put (M**2);
   Put_Line ("M**3 =");   Put (M**3);
   Put_Line ("M**50 =");  Put (M**50);
end Test_Matrix;
