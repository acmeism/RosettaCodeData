pragma Ada_2022;
with Ada.Containers;            use Ada.Containers;
with Ada.Containers.Vectors;
with Ada.Numerics.Discrete_Random;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

procedure Word_Search is

   MIN_WORDS     : constant Positive := 25;
   MIN_WORD_LEN  : constant Positive := 3;
   MAX_WORD_LEN  : constant Positive := 9;
   SIDE_LEN      : constant Positive := 10;
   MESSAGE       : constant String   := "ROSETTACODE";
   DICT_FILENAME : constant String   := "unixdict.txt";

   type Directions is (N, NE, E, SE, S, SW, W, NW);
   type Move is record
      DX, DY : Integer;
   end record;
   type Moves_Arr is array (Directions) of Move;
   Moves : constant Moves_Arr := [
      N => (0, -1), NE => (1, -1), E => (1, 0), SE => (1, 1),
      S => (0, 1), SW => (-1, 1), W => (-1, 0), NW => (-1, -1)
   ];
   subtype Grid_Dimension is Positive range 1 .. SIDE_LEN;
   type Matrix is array (Grid_Dimension, Grid_Dimension) of Character;
   subtype LC_Chars is Character range 'a' .. 'z';
   subtype Valid_Lengths is Positive range MIN_WORD_LEN .. MAX_WORD_LEN;

   package Word_Vectors is new Ada.Containers.Vectors (Positive, Unbounded_String);
   type Dictionary is array (Valid_Lengths) of Word_Vectors.Vector;
   Dict : Dictionary;

   type Placement is record
      Word  : Unbounded_String;
      Start : Unbounded_String;
   end record;
   package Placement_Vectors is new Ada.Containers.Vectors (Positive, Placement);
   Placings : Placement_Vectors.Vector;

   subtype Ten_K is Positive range 1 .. 10000;
   package Rand_Dimension is new Ada.Numerics.Discrete_Random (Grid_Dimension);
   package Rand_Dir is new       Ada.Numerics.Discrete_Random (Directions);
   package Rand_Len is new       Ada.Numerics.Discrete_Random (Valid_Lengths);
   package Rand_10k is new       Ada.Numerics.Discrete_Random (Ten_K);
   Dimension_Gen  : Rand_Dimension.Generator;
   Dir_Gen        : Rand_Dir.Generator;
   Len_Gen        : Rand_Len.Generator;
   Ten_K_Gen      : Rand_10k.Generator;

   procedure Load_Dictionary (Filename : String) is
      Dict_File : File_Type;
      Dict_Word : Unbounded_String;
      Dict_Word_Len : Positive;
      Word_OK   : Boolean;
   begin
      Open (File => Dict_File, Mode => In_File, Name => Filename);
      while not End_Of_File (Dict_File) loop
         Dict_Word := Get_Line (Dict_File);
         Dict_Word_Len := Length (Dict_Word);
         if Dict_Word_Len >= MIN_WORD_LEN and then
            Dict_Word_Len <= MAX_WORD_LEN
         then
            Word_OK := True;
            for C of To_String (Dict_Word) loop
               if C not in LC_Chars then
                  Word_OK := False;
                  exit;
               end if;
            end loop;
            if Word_OK then
               Dict (Dict_Word_Len).Append (Dict_Word);
            end if;
         end if;
      end loop;
   end Load_Dictionary;

   function Pick_Random_Word return Unbounded_String is
      Word_Length : Positive         := Rand_Len.Random (Len_Gen);
      Rand        : constant Natural := Rand_10k.Random (Ten_K_Gen);
      Word_Ix     : Positive;
   begin
      Word_Length := Rand_Len.Random (Len_Gen);
      if Word_Length > 4 then  --  Reduce number of words > 4 chars
         Word_Length := Rand_Len.Random (Len_Gen);
      end if;
      Word_Ix := Positive (Rand) mod (Positive (Dict (Word_Length).Length) - 1) + 1;
      return Dict (Word_Length) (Word_Ix);
   end Pick_Random_Word;

   function Not_Too_Long (X, Y : Grid_Dimension; Len : Positive; Dir : Directions) return Boolean is
   begin
      case Dir is
         when N => return Y - Len > 0;
         when S => return Y + Len <= SIDE_LEN;
         when E => return X + Len <= SIDE_LEN;
         when W => return X - Len > 0;
         when NE => return X + Len <= SIDE_LEN and then Y - Len > 0;
         when SW => return Y + Len <= SIDE_LEN and then X - Len > 0;
         when SE => return Y + Len <= SIDE_LEN and then X + Len <= SIDE_LEN;
         when NW => return Y - Len > 0 and then X - Len > 0;
      end case;
   end Not_Too_Long;

   function Is_Empty (G : Matrix; Row, Col : Positive) return Boolean is
      (G (Row, Col) = ' ');

   function Count_Empties (G : Matrix) return Natural is
      Count : Natural := 0;
   begin
      for Row in Grid_Dimension loop
         for Col in Grid_Dimension loop
            Count := Count + (if Is_Empty (G, Row, Col) then 1 else 0);
         end loop;
      end loop;
      return Count;
   end Count_Empties;

   function Can_Place (G : Matrix; X, Y : Grid_Dimension; Word : Unbounded_String; Dir : Directions)
                       return Boolean is
      GX  : Grid_Dimension := X;
      GY  : Grid_Dimension := Y;
      Len : constant Positive := Length (Word);
   begin
      for C in 1 .. Len loop
         if not Is_Empty (G, GX, GY) and then
            G (GX, GY) /= Element (Word, C)
         then
            return False;
         else
            GX := GX + Moves (Dir).DX;
            GY := GY + Moves (Dir).DY;
         end if;
      end loop;
      return True;
   end Can_Place;

   procedure Insert_Word (G : in out Matrix;
                          X, Y : Grid_Dimension;
                          Dir : Directions;
                          Word : Unbounded_String) is
   --  We assume it fits.  You've checked first haven't you!
      GX : Grid_Dimension := X;
      GY : Grid_Dimension := Y;
   begin
      for C in 1 .. Length (Word) loop
         G (GX, GY) := Element (Word, C);
         GX := GX + Moves (Dir).DX;
         GY := GY + Moves (Dir).DY;
      end loop;
   end Insert_Word;

   function Try_To_Place_Word (G : in out Matrix; Word : Unbounded_String; Max_Tries : Positive)
      return Boolean is
   --  Attempt to place the given word in the grid, return success or failure.
      X1, Y1 : Grid_Dimension;
      Dir    : Directions;
      Try    : Positive := 1;
      Place  : Placement;
   begin
      while Try <= Max_Tries loop
         X1  := Rand_Dimension.Random (Dimension_Gen);
         Y1  := Rand_Dimension.Random (Dimension_Gen);
         Dir := Rand_Dir.Random (Dir_Gen);
         if Not_Too_Long (X1, Y1, Length (Word), Dir) and then
            Can_Place (G, X1, Y1, Word, Dir)
         then
            Insert_Word (G, X1, Y1, Dir, Word);
            Place.Word  := Word;
            Place.Start := To_Unbounded_String (X1'Image & LC_Chars'Val (Integer (Y1) + 64));
            Placings.Append (Place);
            return True;
         end if;
         Try := Try + 1;
      end loop;
      return False;
   end Try_To_Place_Word;

   procedure Print_Matrix (M : Matrix) is
   begin
      Put_Line ("     A B C D E F G H I J"); New_Line;
      for Row in Grid_Dimension loop
         Put (Row'Image);
         Set_Col (6);
         for Col in Grid_Dimension loop
            Put (M (Row, Col) & " ");
         end loop;
         New_Line;
      end loop;
      New_Line;
   end Print_Matrix;

   function Place_Message (G : in out Matrix; Msg : String) return Boolean is
   --  Attempt to put message in grid, return False if unable.
      Msg_Posn : Positive := 1;
   begin
      for Row in Grid_Dimension loop
         for Col in Grid_Dimension loop
            if Is_Empty (G, Row, Col) then
               G (Row, Col) := Msg (Msg_Posn);
               if Msg_Posn = Msg'Length then
                  return True;
               else
                  Msg_Posn := Msg_Posn + 1;
               end if;
            end if;
         end loop;
      end loop;
      return False;
   end Place_Message;

   Grid           : Matrix;
   Words_Placed   : Natural;
   Message_Placed : Boolean;
   A_Word         : Unbounded_String;
   Attempt        : Positive;
   Col            : Positive_Count := 1;
begin
   Load_Dictionary (DICT_FILENAME);
   Rand_Dimension.Reset (Dimension_Gen);
   Rand_Dir.Reset (Dir_Gen);
   Rand_Len.Reset (Len_Gen);
   Rand_10k.Reset (Ten_K_Gen);
   loop
      Grid         := [others => [others => ' ']];
      Words_Placed := 0;  Message_Placed := False;  Placings.Clear;
      Attempt      := 1;
      Builder :
         loop
            A_Word := Pick_Random_Word;
            if Try_To_Place_Word (Grid, A_Word, 50) then
               Words_Placed := @ + 1;
            end if;
            if Count_Empties (Grid) = MESSAGE'Length then
               if Place_Message (Grid, MESSAGE) then
                  Message_Placed := True;
                  exit Builder;
               end if;
            elsif Count_Empties (Grid) < MESSAGE'Length then
               --  Put_Line ("No room for message, giving up.");
               exit Builder;
            elsif Attempt > 1000 then
               Put_Line ("Giving up after 1000 tries.");
               exit Builder;
            end if;
            Attempt := Attempt + 1;
         end loop Builder;
      exit when Words_Placed >= MIN_WORDS and then Message_Placed;
   end loop;
   Print_Matrix (Grid);
   Put_Line ("Words placed:" & Words_Placed'Image);
   for P of Placings loop
      Set_Col (Col);     Put (P.Word);
      Set_Col (Col + 9); Put (P.Start);
      Col := (if Col < 61 then Col + 20 else 1);
   end loop;
end Word_Search;
