with Ada.Text_IO;

procedure Spinning_Rod is
   use Ada.Text_IO;

   type Index_Type is mod 4;
   Rod   : constant array (Index_Type) of Character := ('|', '/', '-', '\');
   Index : Index_Type := 0;
   Char  : Character;
   Avail : Boolean;
begin
   Put (ASCII.ESC & "[?25l");           -- Hide the cursor
   loop
      Put (ASCII.ESC & "[2J");          -- Clear Terminal
      Put (ASCII.ESC & "[0;0H");        -- Place Cursor at Top Left Corner
      Get_Immediate (Char, Avail);
      exit when Avail;
      Put (Rod (Index));
      Index := Index_Type'Succ (Index);
      delay 0.250;
   end loop;
   Put (ASCII.ESC & "[?25h");           -- Restore the cursor
end Spinning_Rod;
