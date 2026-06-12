with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   ESC : constant Character := Character'Val (27);
begin
   Put (ESC & "[31" & "mR");
   Put (ESC & "[32" & "mA");
   Put (ESC & "[33" & "mI");
   Put (ESC & "[34" & "mN");
   Put (ESC & "[35" & "mB");
   Put (ESC & "[36" & "mO");
   Put (ESC & "[37" & "mW");
   New_Line;
end Main;
