with Ada.Text_Io;

procedure Longest_Common_Substring is

   function Common (Left, Right: String) return String is
      Com : array (Left'Range, Right'Range) of Natural := (others => (others => 0));
      Longest : Natural := 0;
      Last    : Natural := 0;
   begin
      for L in Left'Range loop
         for R in Right'Range loop
            if Left (L) = Right (R) then
               if L > Left'First and R > Right'First then
                  Com (L, R) := Com (L - 1, R - 1) + 1;
               else
                  Com (L, R) := 1;
               end if;
               if Com (L, R) > Longest then
                  Longest := Com (L, R);
                  Last    := L;
               end if;
            end if;
         end loop;
      end loop;
      return Left (Last - Longest + 1 .. Last);
   end Common;

begin
   Ada.Text_Io.Put_Line (Common ("thisisatest", "testing123testing"));
end Longest_Common_Substring;
