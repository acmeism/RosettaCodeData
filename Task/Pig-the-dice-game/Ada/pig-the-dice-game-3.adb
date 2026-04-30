with Pig, Ada.Text_IO;

procedure Play_Pig is

   use Pig;

   type Hand is new Actor with record
      Name: String(1 .. 5);
   end record;
   function Roll_More(A: Hand; Self, Opponent: Player'Class) return Boolean;

   function Roll_More(A: Hand; Self, Opponent: Player'Class) return Boolean is
      Ch: Character := ' ';
      use Ada.Text_IO;
   begin
      Put(A.Name & " you:" & Natural'Image(Self.Score) &
            " (opponent:" & Natural'Image(Opponent.Score) &
            ") this round:" & Natural'Image(Self.All_Recent) &
            " this roll:" & Natural'Image(Self.Recent) &
            ";  add to score(+)?");
      Get(Ch);
      return Ch /= '+';
   end Roll_More;

   A1: Hand := (Name => "Alice");
   A2: Hand := (Name => "Bob  ");

   Alice: Boolean;
begin
   Play(A1, A2, Alice);
   Ada.Text_IO.Put_Line("Winner = " & (if Alice then "Alice!" else "Bob!"));
end Play_Pig;
