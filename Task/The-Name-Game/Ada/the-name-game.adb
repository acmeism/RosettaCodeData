with Ada.Characters.Handling;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure The_Name_Game
is
   package ACH renames Ada.Characters.Handling;
   package ASU renames Ada.Strings.Unbounded;
   function "+"(input : in String) return ASU.Unbounded_String renames ASU.To_Unbounded_String;
   function "+"(input : in ASU.Unbounded_String) return String renames ASU.To_String;

   function Normalize_Case(input : in String) return String is
   begin
      return ACH.To_Upper(input(input'First))
        & ACH.To_Lower(input(input'First + 1 .. input'Last));
   end Normalize_Case;

   function Transform(input : in String; letter : in Character) return String is
   begin
      case input(input'First) is
         when 'A' | 'E' | 'I' | 'O' | 'U' =>
            return letter & ACH.To_Lower(input);
         when others =>
            if ACH.To_Lower(input(input'First)) = letter then
               return input(input'First + 1 .. input'Last);
            else
               return letter & input(input'First + 1 .. input'Last);
            end if;
      end case;
   end Transform;

   procedure Lyrics(name : in String)
   is
      normalized : constant String := Normalize_Case(name);
   begin
      Ada.Text_IO.Put_Line(normalized & ", " & normalized & ", bo-" & Transform(normalized, 'b'));
      Ada.Text_IO.Put_Line("Banana-fana, fo-" & Transform(normalized, 'f'));
      Ada.Text_IO.Put_Line("fi-fee-mo-" & Transform(normalized, 'm'));
      Ada.Text_IO.Put_Line(normalized & '!');
      Ada.Text_IO.New_Line;
   end Lyrics;

   names : constant array(1 .. 5) of ASU.Unbounded_String :=
     (+"Gary",
      +"EARL",
      +"billy",
      +"FeLiX",
      +"Mary");
begin
   for name of names loop
      Lyrics(+name);
   end loop;
end The_Name_Game;
