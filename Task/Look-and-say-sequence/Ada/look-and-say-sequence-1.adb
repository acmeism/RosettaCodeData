with Ada.Text_IO, Ada.Strings.Fixed;
use  Ada.Text_IO, Ada.Strings, Ada.Strings.Fixed;

function "+" (S : String) return String is
   Item : constant Character := S (S'First);
begin
   for Index in S'First + 1..S'Last loop
      if Item /= S (Index) then
         return Trim (Integer'Image (Index - S'First), Both) & Item & (+(S (Index..S'Last)));
      end if;
   end loop;
   return Trim (Integer'Image (S'Length), Both) & Item;
end "+";
