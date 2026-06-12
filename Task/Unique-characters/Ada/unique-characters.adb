with Ada.Text_Io;

procedure Unique_Characters is

   List : array (Character) of Natural := (others => 0);

   procedure Count (Item : String) is
   begin
      for C of Item loop
         List (C) := List (C) + 1;
      end loop;
   end Count;

   procedure Put_Only_Once is
      use Ada.Text_Io;
   begin
      for C in List'Range loop
         if List (C) = 1 then
            Put (C);
            Put (' ');
         end if;
      end loop;
      New_Line;
   end Put_Only_Once;

begin
   Count ("133252abcdeeffd");
   Count ("a6789798st");
   Count ("yxcdfgxcyz");
   Put_Only_Once;
end Unique_Characters;
