with Ada.Text_IO;

procedure Longest_Substring is

   function Longest (Item : String) return String is
      Hist  : array (Character) of Natural := (others => 0);
      First         : Natural := Item'First;
      Last          : Natural := Item'First - 1;
      Longest_First : Natural := Item'First;
      Longest_Last  : Natural := Item'First - 1;

      procedure Adjust is
      begin
         if Last - First > Longest_Last - Longest_First then
            Longest_First := First;
            Longest_Last  := Last;
         end if;
      end Adjust;

   begin
      if Item = "" then
         return Item;
      end if;
      for Index in Item'Range loop
         Last := Index;
         Hist (Item (Index)) := Hist (Item (Index)) + 1;
         if Hist (Item (Index)) = 1 then
            Adjust;
         else
            for A in First .. Index loop
               if (for all E of Hist => E <= 1) then
                  First := A;
                  Adjust;
                  exit;
               end if;

               Hist (Item (A)) := Hist (Item (A)) - 1;
            end loop;
         end if;
      end loop;
      return Item (Longest_First .. Longest_Last);
   end Longest;

   procedure Test (Item : String) is
      use Ada.Text_IO;
   begin
      Put ("original : '");  Put (Item);            Put_Line ("'");
      Put ("longest  : '");  Put (Longest (Item));  Put_Line ("'");
   end Test;

begin
   Test ("");
   Test ("a");
   Test ("xyzyabcybdfd");
   Test ("thisisastringtest");
   Test ("zzzzz");
end Longest_Substring;
