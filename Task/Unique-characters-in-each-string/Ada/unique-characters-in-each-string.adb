with Ada.Text_Io;

procedure Unique_Characters is

   type Occurence_Count is array (Character) of Natural;
   type Occurence_List  is array (Positive range <>) of Occurence_Count;

   function Occurences (Item : String) return Occurence_Count is
      Count : Occurence_Count := (others => 0);
   begin
      for C of Item loop
         Count (C) := Count (C) + 1;
      end loop;
      return Count;
   end Occurences;

   procedure Put_Unique (List : Occurence_List) is
      use Ada.Text_Io;
   begin
      for C in List (List'First)'Range loop
         if (for all I in List'Range => List (I) (C) = 1) then
            Put (C);
            Put (' ');
         end if;
      end loop;
   end Put_Unique;

begin
   Put_Unique ((1 => Occurences ("1a3c52debeffd"),
                2 => Occurences ("2b6178c97a938stf"),
                3 => Occurences ("3ycxdb1fgxa2yz")));
end Unique_Characters;
