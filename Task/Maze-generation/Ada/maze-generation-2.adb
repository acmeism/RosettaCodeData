with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

package body Mazes is
   package RNG is new Ada.Numerics.Discrete_Random (Positive);
   package Random_Direction is new Ada.Numerics.Discrete_Random (Directions);

   Generator     : RNG.Generator;
   Dir_Generator : Random_Direction.Generator;

   function "-" (Dir : Directions) return Directions is
   begin
      case Dir is
         when North =>
            return South;
         when South =>
            return North;
         when East =>
            return West;
         when West =>
            return East;
      end case;
   end "-";

   procedure Move
     (Row        : in out Height_Type;
      Column     : in out Width_Type;
      Direction  : Directions;
      Valid_Move : out Boolean)
   is
   begin
      Valid_Move := False;
      case Direction is
         when North =>
            if Row > Height_Type'First then
               Valid_Move := True;
               Row        := Row - 1;
            end if;
         when East =>
            if Column < Width_Type'Last then
               Valid_Move := True;
               Column     := Column + 1;
            end if;
         when West =>
            if Column > Width_Type'First then
               Valid_Move := True;
               Column     := Column - 1;
            end if;
         when South =>
            if Row < Height_Type'Last then
               Valid_Move := True;
               Row        := Row + 1;
            end if;
      end case;
   end Move;

   procedure Depth_First_Algorithm
     (Maze   : in out Maze_Grid;
      Row    : Height_Type;
      Column : Width_Type)
   is
      Next_Row        : Height_Type;
      Next_Column     : Width_Type;
      Next_Direction  : Directions;
      Valid_Direction : Boolean;
      Tested_Wall     : array (Directions) of Boolean := (others => False);
      All_Tested      : Boolean;
   begin
      -- mark as visited
      Maze (Row, Column).Visited := True;
      loop
         -- use random direction
         loop
            Next_Direction := Random_Direction.Random (Dir_Generator);
            exit when not Tested_Wall (Next_Direction);
         end loop;
         Next_Row       := Row;
         Next_Column    := Column;
         Move (Next_Row, Next_Column, Next_Direction, Valid_Direction);
         if Valid_Direction then
            if not Maze (Next_Row, Next_Column).Visited then
               -- connect the two cells
               Maze (Row, Column).Walls (Next_Direction)              :=
                 False;
               Maze (Next_Row, Next_Column).Walls (-Next_Direction)   :=
                 False;
               Depth_First_Algorithm (Maze, Next_Row, Next_Column);
            end if;
         end if;
         Tested_Wall (Next_Direction) := True;
         -- continue as long as there are unvisited neighbours left
         All_Tested := True;
         for D in Directions loop
            All_Tested := All_Tested and Tested_Wall (D);
         end loop;
         -- all directions are either visited (from here,
         -- or previously visited), or invalid.
         exit when All_Tested;
      end loop;
   end Depth_First_Algorithm;

   procedure Initialize (Maze : in out Maze_Grid) is
      Row, Column : Positive;
   begin
      -- initialize random generators
      RNG.Reset (Generator);
      Random_Direction.Reset (Dir_Generator);
      -- choose starting cell
      Row    := RNG.Random (Generator) mod Height + 1;
      Column := RNG.Random (Generator) mod Width + 1;
      Ada.Text_IO.Put_Line
        ("Starting generation at " &
         Positive'Image (Row) &
         " x" &
         Positive'Image (Column));
      Depth_First_Algorithm (Maze, Row, Column);
   end Initialize;

   procedure Put (Item : Maze_Grid) is
   begin
      for Row in Item'Range (1) loop
         if Row = Item'First (1) then
            Ada.Text_IO.Put ('+');
            for Col in Item'Range (2) loop
               if Item (Row, Col).Walls (North) then
                  Ada.Text_IO.Put ("---+");
               else
                  Ada.Text_IO.Put ("   +");
               end if;
            end loop;
            Ada.Text_IO.New_Line;
         end if;
         for Col in Item'Range (2) loop
            if Col = Item'First (2) then
               if Item (Row, Col).Walls (West) then
                  Ada.Text_IO.Put ('|');
               else
                  Ada.Text_IO.Put (' ');
               end if;
            elsif Item (Row, Col).Walls (West)
              and then Item (Row, Col - 1).Walls (East)
            then
               Ada.Text_IO.Put ('|');
            elsif Item (Row, Col).Walls (West)
              or else Item (Row, Col - 1).Walls (East)
            then
               Ada.Text_IO.Put ('>');
            else
               Ada.Text_IO.Put (' ');
            end if;
            if Item (Row, Col).Visited then
               Ada.Text_IO.Put ("   ");
            else
               Ada.Text_IO.Put ("???");
            end if;
         end loop;
         if Item (Row, Item'Last (2)).Walls (East) then
            Ada.Text_IO.Put_Line ("|");
         else
            Ada.Text_IO.Put_Line (" ");
         end if;
         Ada.Text_IO.Put ('+');
         for Col in Item'Range (2) loop
            if Item (Row, Col).Walls (South) then
               Ada.Text_IO.Put ("---+");
            else
               Ada.Text_IO.Put ("   +");
            end if;
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Put;
end Mazes;
