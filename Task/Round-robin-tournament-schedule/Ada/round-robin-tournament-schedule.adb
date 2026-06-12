-- Create a round-robin schedule
-- J. Carter     2023 May
-- Circle method

with Ada.Text_IO;

procedure Round_Robin is
   type Player_ID is range 1 .. 12;

   type Player_List is array (Player_ID) of Player_ID;

   Circle : Player_List;
   J      : Player_ID;
begin -- Round_Robin
   Fill : for I in Circle'Range loop
      Circle (I) := I;
   end loop Fill;

   All_Rounds : for Round in 1 .. Player_ID'Last - 1 loop
      Ada.Text_IO.Put_Line (Item => "Round" & Round'Image);
      J := Player_ID'Last;

      Pairs : for I in 1 .. Player_ID'Last / 2 loop
         Order : declare
            Min : constant Player_ID := Player_ID'Min (Circle (I), Circle (J) );
            Max : constant Player_ID := Player_ID'Max (Circle (I), Circle (J) );
         begin -- Order
            Ada.Text_IO.Put_Line (Item => Min'Image & " v" & Max'Image);
            J := J - 1;
         end Order;
      end loop Pairs;

      Ada.Text_IO.New_Line;
      Circle := Circle (Circle'First) & Circle (Circle'Last) & Circle (Circle'First + 1 .. Circle'Last - 1);
   end loop All_Rounds;
end Round_Robin;
