-- Penney's game
-- J. Carter     2024 Jun

with Ada.Characters.Handling;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

procedure Penney_Game is
   package Random is new Ada.Numerics.Discrete_Random (Result_Subtype => Boolean);

   type Choice_List is array (1 .. 3) of Boolean;

   procedure Get (List : out Choice_List);
   -- Gets the player's choice

   procedure Put (Bool : in Boolean);
   -- Puts False => 'T', True => 'H'

   procedure Put (List : in Choice_List);
   -- Outputs a choice

   type Optimum_Map is array (Boolean, Boolean, Boolean) of Choice_List;

   Optimum : constant Optimum_Map :=
      (False => (False => (False => (True,  False, False), True => (True,  False, False) ),
                 True  => (False => (False, False, True),  True => (False, False, True)  ) ),
       True  => (False => (False => (True,  True,  False), True => (True,  True,  False) ),
                 True  => (False => (False, True,  True),  True => (False, True,  True) ) ) );

   procedure Get (List : out Choice_List) is
      -- Empty
   begin -- Get
      All_Tries : loop
         Ada.Text_IO.Put (Item => "Enter your sequence as three letters, H or T: ");

         One_Try : declare
            Line : constant String := Ada.Characters.Handling.To_Upper (Ada.Text_IO.Get_Line);
         begin -- One_Try
            if Line'Length = 3 and (for all C of Line => C in 'H' |'T') then
               Convert : for I in List'Range loop
                  List (I) := Line (I) = 'H';
               end loop Convert;

               return;
            end if;
         end One_Try;
      end loop All_Tries;
   end Get;

   procedure Put (Bool : in Boolean) is
      -- Empty
   begin -- Put
      Ada.Text_IO.Put (Item => (if Bool then 'H' else 'T') );
   end Put;

   procedure Put (List : in Choice_List) is
      -- Empty
   begin -- Put
      Put_All : for B of List loop
         Put (Bool => B);
      end loop Put_All;
   end Put;

   Gen         : Random.Generator;
   Play_First  : Boolean;
   Comp_Choice : Choice_List;
   Play_Choice : Choice_List;
   Actual      : Choice_List;
begin -- Penney_Game
   Random.Reset (Gen => Gen);
   Play_First := Random.Random (Gen);

   if Play_First then
      Get (List => Play_Choice);
      Comp_Choice := Optimum (Play_Choice (1), Play_Choice (2), Play_Choice (3) );
   else
      Comp_Choice := (others => Random.Random (Gen) );
   end if;

   Ada.Text_IO.Put (Item => "Computer's sequence is ");
   Put (List => Comp_Choice);
   Ada.Text_IO.New_Line;

   if not Play_First then
      Get (List => Play_Choice);
   end if;

   Actual := (others => Random.Random (Gen) );
   Put (List => Actual);

   Check : loop
      if Actual = Comp_Choice or Actual = Play_Choice then
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line (Item => (if Actual = Comp_Choice then "Computer" else "Player") & " wins");

         return;
      end if;

      Actual := Actual (2 .. 3) & Random.Random (Gen);
      Put (Bool => Actual (3) );
   end loop Check;
end Penney_Game;
