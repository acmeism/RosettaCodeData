-- This code is a basic implementation of snake in Ada using the command prompt
-- feel free to improve it!

-- Snake.ads
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Vectors;

package Snake is

   -- copy from 2048 game (
   -- Keyboard management
   type directions is (Up, Down, Right, Left, Quit, Restart, Invalid);

   -- Redefining this standard procedure as function to allow Get_Keystroke as an expression function
   function Get_Immediate return Character;

   Arrow_Prefix : constant Character := Character'Val(224); -- works for windows

   function Get_Keystroke return directions;
   -- )

   -- The container for game data
   type gameBoard is array (Natural range <>, Natural range <>) of Character;

   -- Initilize the board
   procedure init;

   -- Run the game
   procedure run;

   -- Displaying the board
   procedure Display_Board;
   -- Clear the board from content
   procedure ClearBoard;

   -- coordinates data structure
   type coord is tagged record
      X,Y : Integer;
   end record;

   -- list of coordinate (one coordinate for each body part of the snake)
   package snakeBody is new Ada.Containers.Vectors (Natural, coord);
   use snakeBody;

   -- update snake's part depending on the snakeDirection and checking colicion (with borders and snak's part)
   function moveSnake return Boolean;

   -- generate food if it was eaten
   procedure generateFood;

   -- Add snake and food to the board
   procedure addDataToBoard;

   -- generate random integer between 1 and upperBound to generate random food position
   function getRandomInteger(upperBound : Integer) return Integer;

private

   width, height : Positive := 10;
   board : gameBoard := (0 .. (width+1) => (0 .. (height+1) => ' '));
   snake : Vector := (1,1) & (2,1) & (3,1);
   snakeDirection : directions := Right;

   food : coord := (5,5);

end Snake;


-- Snake.adb

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

package body Snake is

   -----------------------------------------------------------------------------
   -- Redefining this standard procedure as function to allow Get_Keystroke as an expression function (copy from 2048 game)
   function Get_Immediate return Character is
   begin
      return Answer : Character do Ada.Text_IO.Get_Immediate(Answer);
      end return;
   end Get_Immediate;

   -----------------------------------------------------------------------------
   -- (copy from 2048 game)
   function Get_Keystroke return directions is
     (case Get_Immediate is
         when 'Q' | 'q' => Quit,
         when 'R' | 'r' => Restart,
         when 'W' | 'w' => Left,
         when 'A' | 'a' => Up,
         when 'S' | 's' => Down,
         when 'D' | 'd' => Right,
         -- Windows terminal
         when Arrow_Prefix => (case Character'Pos(Get_Immediate) is
                                  when 72 => Up,
                                  when 75 => Left,
                                  when 77 => Right,
                                  when 80 => Down,
                                  when others => Invalid),
         -- Unix escape sequences
         when ASCII.ESC => (case Get_Immediate is
                               when '[' => (case Get_Immediate is
                                               when 'A' => Up,
                                               when 'B' => Down,
                                               when 'C' => Right,
                                               when 'D' => Left,
                                               when others => Invalid),
                               when others => Invalid),
         when others => Invalid);

   -----------------------------------------------------------------------------
   procedure init is
   begin

      for Row in 0 .. width+1 loop
         for Column in 0 .. height+1 loop

            if Row = 0 or Row = width+1 then
               board(Row,Column) := '#';
               --  Insert(board(Row,0), Column, '#');
            else
               if Column = 0 or Column = height+1 then
                  board(Row,Column) := '#';
                  --  Insert(board, board(Row, Column), "#");
               else
                  board(Row,Column) := ' ';
                  --  Insert(board, board(Row, Column), " ");
               end if;
            end if;

         end loop;
      end loop;
   end;

   -----------------------------------------------------------------------------
   procedure run is

      task T;
      task body T is
      begin
         loop
            snakeDirection := Get_Keystroke;
         end loop;
      end T;

   begin

      init;
      loop
         exit when snakeDirection = Quit;

         if moveSnake = False then
            Put_Line("GAME OVER!!!");
            Put_Line("Your score is:" & Length(snake)'Image);
            exit;
         end if;


         Display_Board;
         delay 0.7;

      end loop;
   end run;

   -----------------------------------------------------------------------------
   procedure Display_Board is
   begin

      for Row in 0 .. width+1 loop
         for Column in 0 .. height+1 loop
            Put(board(Row, Column));
         end loop;
         New_Line;
      end loop;

   end Display_Board;

   -----------------------------------------------------------------------------
   procedure ClearBoard is
   begin

      for Row in 1 .. width loop
         for Column in 1 .. height loop
            board(Row, Column) := ' ';
         end loop;
      end loop;

   end ClearBoard;

   -----------------------------------------------------------------------------
   function moveSnake return Boolean is
      colision : Boolean := False;
      headCoord : coord := Snake.First_Element;
      addSnakePart : Boolean := False;
   begin

      case snakeDirection is
         when Up => headCoord.X := headCoord.X - 1;
         when Down => headCoord.X := headCoord.X + 1;
         when Right => headCoord.Y := headCoord.Y + 1;
         when Left => headCoord.Y := headCoord.Y - 1;
         when others => null;
      end case;

      if headCoord.Y = height+1 then
         return False;
      end if;

      if headCoord.Y = 0 then
         return False;
      end if;

      if headCoord.X = width+1 then
         return False;
      end if;

      if headCoord.X = 0 then
         return False;
      end if;

      for index in snake.Iterate loop
         if headCoord = snake(To_Index(index)) then
            return False;
         end if;
      end loop;

      snake.Prepend(headCoord);

      if headCoord /= food then
         snake.Delete_Last;
      else
         food := (0,0);
         generateFood;
      end if;

      addDataToBoard;

      return True;
   end moveSnake;

   -----------------------------------------------------------------------------
   procedure generateFood is
   begin
      if food.X = 0 or food.Y = 0 then
         food := (getRandomInteger(width), getRandomInteger(height));
      end if;
   end generateFood;

   -----------------------------------------------------------------------------
   procedure addDataToBoard is
   begin
      ClearBoard;

      board(food.X, food.Y) := '*';

      for index in snake.Iterate loop
         board(snake(To_Index(index)).X, snake(To_Index(index)).Y) := 'o';
      end loop;

   end addDataToBoard;

   -----------------------------------------------------------------------------
   function getRandomInteger(upperBound : Integer) return Integer is

      subtype Random_Range is Integer range 1 .. upperBound;

      package R is new
        Ada.Numerics.Discrete_Random (Random_Range);
      use R;

      G : Generator;
   begin
      Reset (G);
      return Random (G);
   end getRandomInteger;

end Snake;


-- main.adb

with Snake;

procedure Main is
begin
   Snake.run;
end;
