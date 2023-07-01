with Ada.Text_IO; use Ada.Text_IO;
with System.Random_Numbers;
procedure Play_2048 is
   -- ----- Keyboard management
   type t_Keystroke is (Up, Down, Right, Left, Quit, Restart, Invalid);
   -- Redefining this standard procedure as function to allow Get_Keystroke as an expression function
   function Get_Immediate return Character is
   begin
      return Answer : Character do Ada.Text_IO.Get_Immediate(Answer);
      end return;
   end Get_Immediate;
   Arrow_Prefix : constant Character := Character'Val(224); -- works for windows
   function Get_Keystroke return t_Keystroke is
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

   -- ----- Game data
   function Random_Int is new System.Random_Numbers.Random_Discrete(Integer);
   type    t_List  is array (Positive range <>) of Natural;
   subtype t_Row   is t_List (1..4);
   type    t_Board is array  (1..4) of t_Row;
   Board     : t_Board;
   New_Board : t_Board;
   Blanks    : Natural;
   Score     : Natural;
   Generator : System.Random_Numbers.Generator;

   -- ----- Displaying the board
   procedure Display_Board is
      Horizontal_Rule : constant String := "+----+----+----+----+";
      function Center (Value : in String) return String is
        ((1..(2-(Value'Length-1)/2) => ' ') & -- Add leading spaces
         Value(Value'First+1..Value'Last)   & -- Trim the leading space of the raw number image
         (1..(2-Value'Length/2) => ' '));     -- Add trailing spaces
   begin
      Put_Line (Horizontal_Rule);
      for Row of Board loop
         for Cell of Row loop
            Put('|' & (if Cell = 0 then "    " else Center(Cell'Img)));
         end loop;
         Put_Line("|");
         Put_Line (Horizontal_Rule);
      end loop;
      Put_Line("Score =" & Score'Img);
   end Display_Board;

   -- ----- Game mechanics
   procedure Add_Block is
      Block_Offset : Positive := Random_Int(Generator, 1, Blanks);
   begin
      Blanks := Blanks-1;
      for Row of Board loop
         for Cell of Row loop
            if Cell = 0 then
               if Block_Offset = 1 then
                  Cell := (if Random_Int(Generator,1,10) = 1 then 4 else 2);
                  return;
               else
                  Block_Offset := Block_Offset-1;
               end if;
            end if;
         end loop;
      end loop;
   end Add_Block;

   procedure Reset_Game is
   begin
      Board  := (others => (others => 0));
      Blanks := 16;
      Score  := 0;
      Add_Block;
      Add_Block;
   end Reset_Game;

   -- Moving and merging will always be performed leftward, hence the following transforms
   function HFlip (What : in t_Row) return t_Row is
     (What(4),What(3),What(2),What(1));
   function VFlip (What : in t_Board) return t_Board is
     (HFlip(What(1)),HFlip(What(2)),HFlip(What(3)),HFlip(What(4)));
   function Transpose (What : in t_Board) return t_Board is
   begin
      return Answer : t_Board do
         for Row in t_Board'Range loop
            for Column in t_Row'Range loop
               Answer(Column)(Row) := What(Row)(Column);
            end loop;
         end loop;
      end return;
   end Transpose;

   -- For moving/merging, recursive expression functions will be used, but they
   -- can't contain statements, hence the following sub-function used by Merge
   function Add_Blank (Delta_Score : in Natural) return t_List is
   begin
      Blanks := Blanks+1;
      Score  := Score+Delta_Score;
      return (1 => 0);
   end Add_Blank;

   function Move_Row (What : in t_List) return t_List is
     (if What'Length = 1 then What
      elsif What(What'First) = 0
      then Move_Row(What(What'First+1..What'Last)) & (1 => 0)
      else (1 => What(What'First)) & Move_Row(What(What'First+1..What'Last)));

   function Merge (What : in t_List) return t_List is
     (if What'Length <= 1 or else What(What'First) = 0 then What
      elsif What(What'First) = What(What'First+1)
      then (1 => 2*What(What'First)) & Merge(What(What'First+2..What'Last)) & Add_Blank(What(What'First))
      else (1 => What(What'First)) & Merge(What(What'First+1..What'Last)));

   function Move (What : in t_Board) return t_Board is
     (Merge(Move_Row(What(1))),Merge(Move_Row(What(2))),Merge(Move_Row(What(3))),Merge(Move_Row(What(4))));

begin
   System.Random_Numbers.Reset(Generator);

   Main_Loop: loop
      Reset_Game;
      Game_Loop: loop
         Display_Board;
         case Get_Keystroke is
            when Restart => exit Game_Loop;
            when Quit    => exit Main_Loop;
            when Left    => New_Board := Move(Board);
            when Right   => New_Board := VFlip(Move(VFlip(Board)));
            when Up      => New_Board := Transpose(Move(Transpose(Board)));
            when Down    => New_Board := Transpose(VFlip(Move(VFlip(Transpose(Board)))));
            when others  => null;
         end case;

         if New_Board = Board then
            Put_Line ("Invalid move...");
         elsif (for some Row of New_Board => (for some Cell of Row => Cell = 2048)) then
            Display_Board;
            Put_Line ("Win !");
            exit Main_Loop;
         else
            Board := New_Board;
            Add_Block; -- OK since the board has changed
            if Blanks = 0
               and then (for all Row in 1..4 =>
                           (for all Column in 1..3 =>
                                (Board(Row)(Column) /= Board(Row)(Column+1))))
               and then (for all Row in 1..3 =>
                           (for all Column in 1..4 =>
                                (Board(Row)(Column) /= Board(Row+1)(Column)))) then
               Display_Board;
               Put_Line ("Lost !");
               exit Main_Loop;
            end if;
         end if;
      end loop Game_Loop;
   end loop Main_Loop;
end Play_2048;
