-- menu2.adb --
-- rosetta.org menu example
-- GPS 4.3-5 (Debian)

-- note: the use of Unbounded strings is somewhat overkill, except that
-- it allows Ada to handle variable length string data easily
-- ie: differing length menu items text
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings.Unbounded,
     Ada.Strings.Unbounded.Text_IO;

use Ada.Text_IO, Ada.Integer_Text_IO,
    Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;

procedure menu2 is
 package tio  renames Ada.Integer_Text_IO;
  -- rename package to use a shorter name, tio, as integer get prefix
 menu_item : array (1..4) of Unbounded_String;
                -- 4 menu items of any length
 choice    : integer := 0;
                 -- user selection entry value

   procedure show_menu is
-- display the menu options and collect the users input
-- into locally global variable 'choice'
   begin
       for pntr in menu_item'first .. menu_item'last  loop
          put (pntr ); put(" "); put( menu_item(pntr)); new_line;
       end loop;
       put("chose (0 to exit) #:"); tio.get(choice);
   end show_menu;

-- main program --
begin
 menu_item(1) := to_unbounded_string("Fee Fie");
 menu_item(2) := to_unbounded_string("Huff & Puff");
 menu_item(3) := to_unbounded_string("mirror mirror");
 menu_item(4) := to_unbounded_string("tick tock");
         -- setup menu selection strings in an array
 show_menu;

 loop
   if choice in menu_item'range then
     put("you chose #:");
     case choice is
      -- in a real menu, each case would execute appropriate user procedures
  	when 1 => put ( menu_item(choice)); new_line;
        when 2 => put ( menu_item(choice)); new_line;
        when 3 => put ( menu_item(choice)); new_line;
        when 4 => put ( menu_item(choice)); new_line;
        when others => null;
     end case;
  	show_menu;
   else
    	put("Menu selection out of range"); new_line;
    	if choice = 0 then exit; end if;
            -- need a exit option !
    	show_menu;
   end if;
 end loop;

end menu2;
