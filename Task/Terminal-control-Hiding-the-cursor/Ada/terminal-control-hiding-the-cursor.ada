with Ada.Text_Io;

with Ansi;

procedure Hiding is
   use Ada.Text_Io;
begin
   Put ("Hiding the cursor for 2.0 seconds...");
   delay 0.500;
   Put (Ansi.Hide);
   delay 2.000;
   Put ("And showing again.");
   delay 0.500;
   Put (Ansi.Show);
   delay 2.000;
   New_Line;
end Hiding;
