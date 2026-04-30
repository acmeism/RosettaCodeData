with Ada.Text_IO;        use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;

procedure Test_Slices is
   Str : constant String := "abcdefgh";
   N : constant := 2;
   M : constant := 3;
begin
   Put_Line (Str (Str'First + N - 1..Str'First + N + M - 2));
   Put_Line (Str (Str'First + N - 1..Str'Last));
   Put_Line (Str (Str'First..Str'Last - 1));
   Put_Line (Head (Tail (Str, Str'Last - Index (Str, "d", 1)), M));
   Put_Line (Head (Tail (Str, Str'Last - Index (Str, "de", 1) - 1), M));
end Test_Slices;
