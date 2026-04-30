with Ada.Text_IO; use Ada.Text_IO;

procedure McNugget is
   Limit : constant                      := 100;
   List  : array (0 .. Limit) of Boolean := (others => False);
   N     : Integer;
begin
   for A in 0 .. Limit / 6 loop
      for B in 0 .. Limit / 9 loop
         for C in 0 .. Limit / 20 loop
            N := A * 6 + B * 9 + C * 20;
            if N <= 100 then
               List (N) := True;
            end if;
         end loop;
      end loop;
   end loop;
   for N in reverse 1 .. Limit loop
      if not List (N) then
         Put_Line ("The largest non McNugget number is:" & Integer'Image (N));
         exit;
      end if;
   end loop;
end McNugget;
