with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Best_Shuffle is

   function Best_Shuffle (S : String) return String;

   function Best_Shuffle (S : String) return String is
      T : String (S'Range) := S;
      Tmp : Character;
   begin
      for I in S'Range loop
         for J in S'Range loop
            if I /= J and S (I) /= T (J) and S (J) /= T (I) then
               Tmp  := T (I);
               T (I) := T (J);
               T (J) := Tmp;
            end if;
         end loop;
      end loop;
      return T;
   end Best_Shuffle;

   Test_Cases : constant array (1 .. 6)
     of Ada.Strings.Unbounded.Unbounded_String :=
                  (Ada.Strings.Unbounded.To_Unbounded_String ("abracadabra"),
                   Ada.Strings.Unbounded.To_Unbounded_String ("seesaw"),
                   Ada.Strings.Unbounded.To_Unbounded_String ("elk"),
                   Ada.Strings.Unbounded.To_Unbounded_String ("grrrrrr"),
                   Ada.Strings.Unbounded.To_Unbounded_String ("up"),
                   Ada.Strings.Unbounded.To_Unbounded_String ("a"));

begin -- main procedure
   for Test_Case in Test_Cases'Range loop
      declare
         Original : constant String := Ada.Strings.Unbounded.To_String
           (Test_Cases (Test_Case));
         Shuffle  : constant String := Best_Shuffle (Original);
         Score : Natural := 0;
      begin
         for I in Original'Range loop
            if Original (I) = Shuffle (I) then
               Score := Score + 1;
            end if;
         end loop;
         Ada.Text_IO.Put_Line (Original & ", " & Shuffle & ", (" &
                                Natural'Image (Score) & " )");
      end;
   end loop;
end Best_Shuffle;
