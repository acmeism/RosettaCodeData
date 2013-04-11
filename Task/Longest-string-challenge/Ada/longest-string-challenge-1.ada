with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO, Ada.Characters.Latin_1;

procedure Longest_String_Challenge is
   function "+"(S: String) return Unbounded_String renames To_Unbounded_String;
   Separator: constant Character := Ada.Characters.Latin_1.NUL;

   procedure Funny_Stuff(B, L: in out Unbounded_String; N: Unbounded_String) is
      Nat: Natural;
   begin
      Nat := Length(N) - Length(L);
      declare
         Pos: Positive;
      begin
         Pos := Nat;
         B   := N;
         L   := N;
      exception
         when Constraint_Error => B := B & Separator & N;
      end;
   exception
      when Constraint_Error => null;
   end Funny_Stuff;

   Buffer: Unbounded_String := +"";
   Longest: Unbounded_String := +"";
   Next: Unbounded_String;

begin
   while True loop
      Next := + Ada.Text_IO.Get_Line;
      Funny_Stuff(Buffer, Longest, Next);
   end loop;
exception
   when others =>
      for I in To_String(Buffer)'Range loop
         if To_String(Buffer)(I) = Separator then
            Ada.Text_IO.New_Line;
         else
            Ada.Text_IO.Put(To_String(Buffer)(I));
         end if;
      end loop;
end Longest_String_Challenge;
