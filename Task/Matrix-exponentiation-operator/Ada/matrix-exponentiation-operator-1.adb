with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Matrix is
   generic
      type Element is private;
      Zero : Element;
      One  : Element;
      with function "+" (A, B : Element) return Element is <>;
      with function "*" (A, B : Element) return Element is <>;
      with function Image (X : Element) return String is <>;
   package Matrices is
      type Matrix is array (Integer range <>, Integer range <>) of Element;
      function "*" (A, B : Matrix) return Matrix;
      function "**" (A : Matrix; Power : Natural) return Matrix;
      procedure Put (A : Matrix);
   end Matrices;

   package body Matrices is
      function "*" (A, B : Matrix) return Matrix is
         R   : Matrix (A'Range (1), B'Range (2));
         Sum : Element := Zero;
      begin
         for I in R'Range (1) loop
            for J in R'Range (2) loop
               Sum := Zero;
               for K in A'Range (2) loop
                  Sum := Sum + A (I, K) * B (K, J);
               end loop;
               R (I, J) := Sum;
            end loop;
         end loop;
         return R;
      end "*";

      function "**" (A : Matrix; Power : Natural) return Matrix is
      begin
         if Power = 1 then
            return A;
         end if;
         declare
            R : Matrix (A'Range (1), A'Range (2)) := (others => (others => Zero));
            P : Matrix  := A;
            E : Natural := Power;
         begin
            for I in P'Range (1) loop -- R is identity matrix
               R (I, I) := One;
            end loop;
            if E = 0 then
               return R;
            end if;
            loop
               if E mod 2 /= 0 then
                  R := R * P;
               end if;
               E := E / 2;
               exit when E = 0;
               P := P * P;
            end loop;
            return R;
         end;
      end "**";

      procedure Put (A : Matrix) is
      begin
         for I in A'Range (1) loop
            for J in A'Range (1) loop
               Put (Image (A (I, J)));
            end loop;
            New_Line;
         end loop;
      end Put;
   end Matrices;

   package Integer_Matrices is new Matrices (Integer, 0, 1, Image => Integer'Image);
   use Integer_Matrices;

   M : Matrix (1..2, 1..2) := ((3,2),(2,1));
begin
   Put_Line ("M =");       Put (M);
   Put_Line ("M**0 =");    Put (M**0);
   Put_Line ("M**1 =");    Put (M**1);
   Put_Line ("M**2 =");    Put (M**2);
   Put_Line ("M*M =");     Put (M*M);
   Put_Line ("M**3 =");    Put (M**3);
   Put_Line ("M*M*M =");   Put (M*M*M);
   Put_Line ("M**4 =");    Put (M**4);
   Put_Line ("M*M*M*M ="); Put (M*M*M*M);
   Put_Line ("M**10 =");   Put (M**10);
   Put_Line ("M*M*M*M*M*M*M*M*M*M ="); Put (M*M*M*M*M*M*M*M*M*M);
end Test_Matrix;
