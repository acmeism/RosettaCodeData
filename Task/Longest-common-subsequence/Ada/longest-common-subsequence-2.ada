with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_LCS is
   function LCS (A, B : String) return String is
      L : array (A'First..A'Last + 1, B'First..B'Last + 1) of Natural;
   begin
      for I in L'Range (1) loop
         L (I, B'First) := 0;
      end loop;
      for J in L'Range (2) loop
         L (A'First, J) := 0;
      end loop;
      for I in A'Range loop
         for J in B'Range loop
            if A (I) = B (J) then
               L (I + 1, J + 1) := L (I, J) + 1;
            else
               L (I + 1, J + 1) := Natural'Max (L (I + 1, J), L (I, J + 1));
            end if;
         end loop;
      end loop;
      declare
         I : Integer := L'Last (1);
         J : Integer := L'Last (2);
         R : String (1..Integer'Max (A'Length, B'Length));
         K : Integer := R'Last;
      begin
         while I > L'First (1) and then J > L'First (2) loop
            if L (I, J) = L (I - 1, J) then
               I := I - 1;
            elsif L (I, J) = L (I, J - 1) then
               J := J - 1;
            else
               I := I - 1;
               J := J - 1;
               R (K) := A (I);
               K := K - 1;
            end if;
         end loop;
         return R (K + 1..R'Last);
      end;
   end LCS;
begin
   Put_Line (LCS ("thisisatest", "testing123testing"));
end Test_LCS;
