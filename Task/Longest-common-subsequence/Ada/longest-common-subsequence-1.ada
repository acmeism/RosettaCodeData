with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_LCS is
   function LCS (A, B : String) return String is
   begin
      if A'Length = 0 or else B'Length = 0 then
         return "";
      elsif A (A'Last) = B (B'Last) then
         return LCS (A (A'First..A'Last - 1), B (B'First..B'Last - 1)) & A (A'Last);
      else
         declare
            X : String renames LCS (A, B (B'First..B'Last - 1));
            Y : String renames LCS (A (A'First..A'Last - 1), B);
         begin
            if X'Length > Y'Length then
               return X;
            else
               return Y;
            end if;
         end;
      end if;
   end LCS;
begin
   Put_Line (LCS ("thisisatest", "testing123testing"));
end Test_LCS;
