with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Wumpus is

   -- enumeration for commands
   type action is (move, shoot, quit);

   -- Constant value 2-d array to represent the dodecahedron room structure

   subtype Room_Number is Integer range 0 .. 19;
   subtype Adjacencies is Integer range 0 .. 2;

   type Rooms is array (Room_Number, Adjacencies) of Integer;

   Adjacent_Rooms : constant Rooms :=
     ((1, 4, 7), (0, 2, 9), (1, 3, 11), (2, 3, 13), (0, 3, 5), (4, 6, 14),
      (5, 7, 16), (0, 6, 8), (7, 9, 17), (1, 8, 10), (9, 11, 18), (2, 10, 12),
      (11, 13, 19), (3, 12, 14), (5, 13, 15), (14, 16, 19), (5, 15, 17),
      (8, 16, 18), (10, 17, 19), (12, 15, 18));

   -- Game global variables
   Current_Room      : Room_Number; -- The index number of the current room.
   Starting_Position : Room_Number;
   Wumpus_Room       : Room_Number;
   Bat1_Room         : Room_Number;
   Bat2_Room         : Room_Number;
   Pit1_Room         : Room_Number;
   Pit2_Room         : Room_Number;
   Wumpus_Start      : Room_Number;
   Bat1_Start        : Room_Number;
   Bat2_Start        : Room_Number;
   Player_Alive      : Boolean;
   Wumpus_Alive      : Boolean;

   subtype Arrow_Count is Integer range 0 .. 5;
   Num_Arrows : Arrow_Count := 5;

   procedure Inspect_Current_Room;

   procedure Place_Pits is
      -- Pits randomly placed in any room except room 0
      subtype pit_rooms is Room_Number range 1 .. 19;
      package rand_pit is new Ada.Numerics.Discrete_Random (pit_rooms);
      use rand_pit;
      Seed : Generator;
   begin
      Reset (Seed);
      Pit1_Room := Random (Seed);
      Pit2_Room := Random (Seed);
   end Place_Pits;

   -- Place bats throughout the map ensuring that the bats will not be placed
   -- in the same room as another bat or the wumpus or room 0

   procedure Place_Bats is
      subtype bat_rooms is Room_Number range 1 .. 19;
      package rand_bat is new Ada.Numerics.Discrete_Random (bat_rooms);
      use rand_bat;
      Seed : Generator;
   begin
      Reset (Seed);
      loop
         Bat1_Room := Random (Seed);
         exit when Bat1_Room /= Wumpus_Room;
      end loop;
      loop
         Bat2_Room := Random (Seed);
         exit when Bat2_Room /= Bat1_Room and Bat2_Room /= Wumpus_Room;
      end loop;
      Bat1_Start := Bat1_Room;
      Bat2_Start := Bat2_Room;
   end Place_Bats;

   -- Place the Wumpus in any room except room 0

   procedure Place_Wumpus is
      subtype Wump_Rooms is Room_Number range 1 .. 19;
      package rand_wump is new Ada.Numerics.Discrete_Random (Wump_Rooms);
      use rand_wump;
      Seed : Generator;
   begin
      Wumpus_Room  := Random (Seed);
      Wumpus_Start := Wumpus_Room;
   end Place_Wumpus;

   -- Place the player in room 0

   procedure Place_Player is

   begin
      Starting_Position := 0;
      Current_Room      := 0;
   end Place_Player;

-- returns True if Room_Id is adjacent to the specified room

   function Is_Room_Adjacent
     (Cur : Room_Number; Next : Room_Number) return Boolean
   is
   begin
      for I in Adjacencies loop
         if Adjacent_Rooms (Cur, I) = Next then
            return True;
         end if;
      end loop;
      return False;
   end Is_Room_Adjacent;

   -- Validates a move is to an adjacent room

   function Is_Valid_Move (Room_Id : in Room_Number) return Boolean is
   begin
      return Is_Room_Adjacent (Current_Room, Room_Id);
   end Is_Valid_Move;

   procedure Move_Startled_Wumpus is
      package rand_move is new Ada.Numerics.Discrete_Random (Adjacencies);
      use rand_move;
      Seed     : Generator;
      New_Room : Adjacencies;
   begin
      Reset (Seed);
      New_Room    := Random (Seed);
      Wumpus_Room := Adjacent_Rooms (Wumpus_Room, New_Room);
   end Move_Startled_Wumpus;

   -- Restarts the game from tthe beginning

   procedure Play_Again is
      Reply : Character;

   begin
      Put_Line
        ("Would you like to replay the same map? Enter Y to play again.");
      Get (Reply);
      Skip_Line;
      if Reply = 'y' or Reply = 'Y' then
         Current_Room := Starting_Position;
         Wumpus_Room  := Wumpus_Start;
         Bat1_Room    := Bat1_Start;
         Bat2_Room    := Bat2_Start;
         Num_Arrows   := 5;
         Put_Line ("Try not to die this time.");
         Inspect_Current_Room;
      else
         Player_Alive := False;
      end if;
   end Play_Again;

   procedure Perform_Action (Act : action);

   -- Starts a new game
   procedure Play_Game is
      package act_io is new Enumeration_IO (action);
      use act_io;
      Choice : action;
   begin
      Put_Line ("Runing the game.");

      -- Initialize the game
      Place_Wumpus;
      Place_Bats;
      Place_Pits;
      Place_Player;

      -- Game set up
      Player_Alive := True;
      Wumpus_Alive := True;
      Num_Arrows   := 5;

      -- Inspects the initial room
      Inspect_Current_Room;

      -- Main game loop

      while Player_Alive and then Wumpus_Alive loop
         Put_Line ("Enter an action choice.");
         Put_Line ("Move");
         Put_Line ("Shoot");
         Put_Line ("Quit");
         Put (">>> ");
         loop
            Put ("Please make a selection: ");
            begin
               Get (Choice);
               Perform_Action (Choice);
               exit;
            exception
               when others =>
                  Put_Line ("Invalid choice. Please try again.");
            end;
         end loop;
      end loop;
   end Play_Game;

   -- Inspects the current room.
   -- This procedure checks for being in the same room as the wumpus, bats, or
   -- pits. It also checks adjacent rooms for those items. It prints out the
   -- room description

   procedure Inspect_Current_Room is
      subtype bat_rooms is Room_Number range 1 .. 19;
      package rand_bat is new Ada.Numerics.Discrete_Random (bat_rooms);
      use rand_bat;
      Seed          : Generator;
      Room_bat_Left : Room_Number := Current_Room;
   begin
      if Current_Room = Wumpus_Room then
         Put_Line ("The Wumpus ate you!!!");
         Put_Line ("LOSER!!!");
         Play_Again;
      elsif Current_Room = Bat1_Room or else Current_Room = Bat2_Room then
         Put_Line ("Snatched by superbats!!");
         if Current_Room = Pit1_Room or Current_Room = Pit2_Room then
            Put_Line ("Luckily, the bat saved you from the bottomless pit!!");
         end if;
         Reset (Seed);
         loop
            Current_Room := Random (Seed);
            exit when Current_Room /= Bat1_Room
              and then Current_Room /= Bat2_Room;
         end loop;
         Put_Line ("The bat moved you to room" & Current_Room'Image);
         Inspect_Current_Room;

         if Room_bat_Left = Bat1_Room then
            loop
               Bat1_Room := Random (Seed);
               exit when Bat1_Room /= Current_Room
                 and then Bat1_Room /= Wumpus_Room
                 and then Bat1_Room /= Bat2_Room;
            end loop;
         else
            loop
               Bat2_Room := Random (Seed);
               exit when Bat2_Room /= Current_Room
                 and then Bat2_Room /= Wumpus_Room
                 and then Bat2_Room /= Bat1_Room;
            end loop;
         end if;
      elsif Current_Room = Pit1_Room or else Current_Room = Pit2_Room then
         Put_Line ("YYYIIIIIEEEEEE.... fell in a pit!!");
         Put_Line ("GAME OVER LOSER!!!");
         Play_Again;
      else
         Put_Line ("You are in room" & Current_Room'Image);
         if Is_Room_Adjacent (Current_Room, Wumpus_Room) then
            Put_Line ("You smell a horrid stench...");
         end if;
         if Is_Room_Adjacent (Current_Room, Bat1_Room)
           or else Is_Room_Adjacent (Current_Room, Bat2_Room)
         then
            Put_Line ("Bats nearby...");
         end if;
         if Is_Room_Adjacent (Current_Room, Pit1_Room)
           or else Is_Room_Adjacent (Current_Room, Pit2_Room)
         then
            Put_Line ("You feel a draft...");
         end if;
         Put_Line ("Tunnels lead to rooms");
         for I in Adjacencies loop
            Put (Item => Adjacent_Rooms (Current_Room, I), Width => 3);
         end loop;
         New_Line;
      end if;
   end Inspect_Current_Room;

   -- Performs the action specified as the procedure argument
   procedure Perform_Action (Act : action) is
      New_Room : Room_Number;
      Resp     : Character;
   begin
      case Act is
         when move =>
            Put_Line ("Which room?");
            begin
               Get (New_Room);
               if Is_Valid_Move (New_Room) then
                  Current_Room := New_Room;
                  Inspect_Current_Room;
               else
                  Put_Line ("You cannot move there.");
               end if;
            exception
               when others =>
                  Put_Line ("You cannot move there.");
            end;
         when shoot =>
            if Num_Arrows > 0 then
               Put_Line ("Which room?");
               begin
                  Get (New_Room);
                  if Is_Valid_Move (New_Room) then
                     Num_Arrows := Num_Arrows - 1;
                     if New_Room = Wumpus_Room then
                        Put_Line ("ARGH.. SPLAT!");
                        Put_Line
                          ("Contratulations! You killed the Wumpus! You Win.");
                        Put_Line ("Type 'Y' to return to the main menu.");
                        Wumpus_Alive := False;
                        Get (Resp);
                        Skip_Line;
                     else
                        Put_Line ("Miss! But you startled the Wumpus");
                        Move_Startled_Wumpus;
                        Put_Line ("Arrows Left:" & Num_Arrows'Image);
                        if Wumpus_Room = Current_Room then
                           Put_Line
                             ("The Wumpus attacked you!." &
                              " You've been killed.");
                           Put_Line ("Game Over!");
                           Play_Again;
                        end if;
                     end if;
                  else
                     Put_Line ("You cannot shoot there.");
                  end if;
               exception
                  when others =>
                     Put_Line ("You cannot shoot there.");
               end;
            else
               Put_Line ("You do not have any arrows!");
            end if;
         when quit =>
            Put_Line ("Quitting the current game.");
            Player_Alive := False;
      end case;
   end Perform_Action;

   -- outputs instructions to standard output

   procedure Print_Instructions is
      C : Character;
   begin
      Put_Line (" Welcome to 'Hunt the Wumpus'! ");
      Put_Line
        (" The wumpus lives in a cave of 20 rooms. Each room has 3 tunnels leading to");
      Put_Line
        (" other rooms. (Look at a dodecahedron to see how this works - if you don't know");
      Put_Line (" what a dodecahedron is, ask someone).");
      New_Line;
      Put_Line (" Hazards:");
      New_Line;
      Put_Line
        (" Bottomless pits - two rooms have bottomless pits in them. If you go there, you ");
      Put_Line (" fall into the pit (& lose!)");
      New_Line;
      Put_Line
        (" Super bats - two other rooms have super bats.  If you go there, a bat grabs you");
      Put_Line
        (" and takes you to some other room at random. (Which may be troublesome). Once the");
      Put_Line
        (" bat has moved you, that bat moves to another random location on the map.");
      New_Line (2);
      Put_Line (" Wumpus");
      Put_Line
        (" The wumpus is not bothered by hazards (he has sucker feet and is too big for a");
      Put_Line
        (" bat to lift).  Usually he is asleep.  Two things wake him up: you shooting an");
      Put_Line
        (" arrow or you entering his room. If the wumpus wakes he moves (p=.75) one room or ");
      Put_Line
        (" stays still (p=.25). After that, if he is where you are, he eats you up and you lose!");
      New_Line;
      Put_Line (" You");
      New_Line;
      Put_Line
        (" Each turn you may move, save or shoot an arrow using the commands move, save, & shoot.");
      Put_Line (" Moving: you can move one room (thru one tunnel).");
      Put_Line
        (" Arrows: you have 5 arrows. You lose when you run out. You aim by telling the");
      Put_Line
        (" computer the rooms you want the arrow to shoot to. If the arrow can't go that way");
      Put_Line (" (if no tunnel), the arrow will not fire.");
      New_Line;
      Put_Line (" Warnings");
      New_Line;
      Put_Line
        (" When you are one room away from a wumpus or hazard, the computer says:");
      Put_Line (" Wumpus: 'I smell a wumpus'");
      Put_Line (" Bat: 'Bats nearby'");
      Put_Line (" Pit: 'I feel a draft'");
      New_Line;

      Put_Line ("Press Y to return to the main menu.");
      Get_Immediate (C);
      Skip_Line;
   end Print_Instructions;

   ----------------
   -- Start_Game --
   ----------------

   procedure Start_Game is
      subtype Response is Integer range 1 .. 3;
      Choice : Response;
   begin
      loop
         Put_Line ("Welcome to Hunt The Wumpus.");
         Put_Line ("1) Play Game");
         Put_Line ("2) Print Instructions");
         Put_Line ("3) Quit");
         Put ("Please make a selection: ");
         begin
            Get (Choice);
            Skip_Line;
            case Choice is
               when 1 =>
                  Play_Game;
               when 2 =>
                  Print_Instructions;
               when 3 =>
                  Put_Line ("Quitting.");
                  exit;
            end case;
         exception
            when others =>
               Skip_Line;
               Put_Line ("Invalid choice. Please enter a 1, 2 or 3");
         end;
      end loop;
   end Start_Game;

end Wumpus;
