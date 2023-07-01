package Bubble
is

   type Arr is array(Integer range <>) of Integer;

   procedure Sort (A : in out Arr);
   --# derives A from *;

end Bubble;


package body Bubble
is
   procedure Sort (A : in out Arr)
   is
      Finished : Boolean;
      Temp     : Integer;
   begin
      if A'Last /= A'First then
         loop
            Finished := True;
            for J in Integer range A'First .. A'Last - 1 loop
               if A (J + 1) < A (J) then
                  Finished := False;
                  Temp := A (J + 1);
                  A (J + 1) := A (J);
                  A (J) := Temp;
               end if;
            end loop;
            --# assert A'Last /= A'First;
            exit when Finished;
         end loop;
      end if;
   end Sort;

end Bubble;
