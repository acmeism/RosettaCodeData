with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

package body Mazes is
   package RNG is new Ada.Numerics.Discrete_Random (Positive);
   package Random_Direction is new Ada.Numerics.Discrete_Random (Directions);

   Generator     : RNG.Generator;
   Dir_Generator : Random_Direction.Generator;

   function "-" (Dir : Directions) return Directions;

   procedure Depth_First_Algorithm
     (Maze   : in out Maze_Grid;
      Row    : Height_Type;
      Column : Width_Type);

   function Has_Unvisited_Neighbours
     (Maze   : Maze_Grid;
      Row    : Height_Type;
      Column : Width_Type)
      return   Boolean;

   procedure Move
     (Row        : in out Height_Type;
      Column     : in out Width_Type;
      Direction  : Directions;
      Valid_Move : out Boolean);

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

   procedure Depth_First_Algorithm
     (Maze   : in out Maze_Grid;
      Row    : Height_Type;
      Column : Width_Type)
   is
      Next_Row        : Height_Type;
      Next_Column     : Width_Type;
      Next_Direction  : Directions;
      Valid_Direction : Boolean;
   begin
      -- mark as visited
      Maze (Row, Column).Visited := True;
      -- continue as long as there are unvisited neighbours left
      while Has_Unvisited_Neighbours (Maze, Row, Column) loop
         -- use random direction
         Next_Direction := Random_Direction.Random (Dir_Generator);
         Next_Row       := Row;
         Next_Column    := Column;
         Move (Next_Row, Next_Column, Next_Direction, Valid_Direction);
         if Valid_Direction then
            -- connect the two cells
            if not Maze (Next_Row, Next_Column).Visited then
               Maze (Row, Column).Walls (Next_Direction)              :=
                 False;
               Maze (Next_Row, Next_Column).Walls (-Next_Direction)   :=
                 False;
               Depth_First_Algorithm (Maze, Next_Row, Next_Column);
            end if;
         end if;
      end loop;
   end Depth_First_Algorithm;

   function Has_Unvisited_Neighbours
     (Maze   : Maze_Grid;
      Row    : Height_Type;
      Column : Width_Type)
      return   Boolean
   is
      Neighbour_Row    : Height_Type;
      Neighbour_Column : Width_Type;
      Is_Valid         : Boolean;
   begin
      for Dir in Directions loop
         Neighbour_Row    := Row;
         Neighbour_Column := Column;
         Move
           (Row        => Neighbour_Row,
            Column     => Neighbour_Column,
            Direction  => Dir,
            Valid_Move => Is_Valid);
         if Is_Valid
           and then not Maze (Neighbour_Row, Neighbour_Column).Visited
         then
            return True;
         end if;
      end loop;
      return False;
   end Has_Unvisited_Neighbours;

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

   procedure Put (Item : Maze_Grid) is
   begin
      for Row in Item'Range (1) loop
         if Row = Item'First (1) then
            for Col in Item'Range (2) loop
               if Col = Item'First (2) then
                  Ada.Text_IO.Put ('+');
               end if;
               if Item (Row, Col).Walls (North) then
                  Ada.Text_IO.Put ("---");
               else
                  Ada.Text_IO.Put ("   ");
               end if;
               Ada.Text_IO.Put ('+');
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
            if Col = Item'Last (2) then
               if Item (Row, Col).Walls (East) then
                  Ada.Text_IO.Put ('|');
               else
                  Ada.Text_IO.Put (' ');
               end if;
            end if;
         end loop;
         Ada.Text_IO.New_Line;
         for Col in Item'Range (2) loop
            --for Col in Item'Range (2) loop
            if Col = Item'First (2) then
               Ada.Text_IO.Put ('+');
            end if;
            if Item (Row, Col).Walls (South) then
               Ada.Text_IO.Put ("---");
            else
               Ada.Text_IO.Put ("   ");
            end if;
            Ada.Text_IO.Put ('+');
            --end loop;
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Put;
end Mazes;
