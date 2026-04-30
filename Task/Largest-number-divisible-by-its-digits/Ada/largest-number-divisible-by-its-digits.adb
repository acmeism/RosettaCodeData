-- Largest number divisible by its digits; analysis under Raku
-- J. Carter     2024 May

with Ada.Text_IO;

procedure LNDBID is
   Magic : constant := 9 * 8 * 7;

   function Good (Number : in Positive) return Boolean;
   -- Returns True if Number's decimal representation has only unique digits and is evenly divisible by each of its digits

   function Good (Number : in Positive) return Boolean is
      subtype Digit is Character range '1' .. '9';

      type Count_List is array (Digit) of Natural;

      Count : Count_List := (Digit => 0);

      Raw   : String renames Number'Image;
      Image : String renames Raw (2 .. Raw'Last);
   begin -- Good
      if (for some D of Image => D in '0' | '5') then
         return False;
      end if;

      Count_Them : for D of Image loop
         Count (D) := Count (D) + 1;
      end loop Count_Them;

      if (for some V of Count => V > 1) then
         return False;
      end if;

      return (for all D of Image => Number rem (Character'Pos (D) - Character'Pos ('0') ) = 0);
   end Good;

   Number : Positive := Magic * (9876432 / Magic);
begin -- LNDBID
   Check : loop
      if Good (Number) then
         Ada.Text_IO.Put_Line (Item => Number'Image);

         return;
      end if;

      Number := Number - Magic;
   end loop Check;
end LNDBID;
