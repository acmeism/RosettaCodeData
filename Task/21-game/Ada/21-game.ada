with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Game_21 is

   procedure Put (Item : String) is
   begin
      for Char of Item loop
         Ada.Text_IO.Put (Char);
         delay 0.010;
      end loop;
   end Put;

   procedure New_Line is
   begin
      Ada.Text_IO.New_Line;
   end New_Line;

   procedure Put_Line (Item : String) is
   begin
      Put (Item);
      New_Line;
   end Put_LIne;

   type Player_Kind is (Human, Computer);
   type Score_Type  is range 0 .. 21;
   subtype Amount_Range is Score_Type range 1 .. 3;

   package Amount_Generators is
     new Ada.Numerics.Discrete_Random (Amount_Range);

   Gen    : Amount_Generators.Generator;
   Total  : Score_Type := 0;
   Choice : Character;
   Player : Player_Kind;
   Amount : Amount_Range;
begin
   Amount_Generators.Reset (Gen);

   Put_Line ("--- The 21 Game ---"); New_Line;

   Put ("Who is starting human or computer (h/c) ? ");
   Ada.Text_IO.Get_Immediate (Choice);
   New_Line;

   case Choice is
      when 'c' | 'C' =>  Player := Computer;
      when 'h' | 'H' =>  Player := Human;
      when others => return;
   end case;

   Play_Loop : loop
      New_Line;
      Put ("Runing total is "); Put (Total'Image); New_Line;
      New_Line;

      case Player is

         when Human =>
            Put_Line ("It is your turn !");
            Input_Loop : loop
               Put ("Enter choice 1 .. 3 (0 to end) : ");
               Ada.Text_IO.Get_Immediate (Choice);

               case Choice is
                  when '1' .. '3' =>
                     Amount := Amount_Range'Value ("" & Choice);
                     exit Input_Loop;

                  when '0' =>
                     exit Play_Loop;

                  when others =>
                     Put_Line ("Choice must be in 1 .. 3");
               end case;
            end loop Input_Loop;
            New_Line;

         when Computer =>
            delay 1.500;
            Amount := Amount_Generators.Random (Gen);
            Put ("Computer chooses: "); Put (Amount'Image); New_Line;
            delay 0.800;

      end case;

      New_Line;
      Amount := Score_Type'Min (Amount, Score_Type'Last - Total);
      Put ("  "); Put (Total'Image); Put (" + ");  Put (Amount'Image); Put (" = ");
      Total := Total + Amount;
      Put (Total'Image);
      New_Line;

      if Total = 21 then
         New_Line;
         Put ("... and we have a WINNER !!"); New_Line;
         delay 0.500;
         Put_Line ("   ... and the winner is ...");
         delay 1.000;
         Put_Line ("      " & Player'Image);
         exit;
      end if;

      Player := (case Player is
                 when Computer => Human,
                 when Human    => Computer);
   end loop Play_Loop;
end Game_21;
