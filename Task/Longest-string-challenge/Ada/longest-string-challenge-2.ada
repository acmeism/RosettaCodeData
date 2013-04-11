with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO, Ada.Characters.Latin_1;

procedure Longest_String_Challenge is
   function "+"(S: String) return Unbounded_String renames To_Unbounded_String;
   function "-"(U: Unbounded_String) return String renames To_String;
   Separator: constant Character := Ada.Characters.Latin_1.NUL;

   procedure Funny_Stuff(B, L: in out Unbounded_String;
                         N: Unbounded_String;
                         S, T: String) is
      C: Character;
   begin
      if S = T then
         B := B & Separator & N;
      else
         C:= T(T'First); -- raises Constraint_Error if T is empty
         begin
            C := S(S'First); -- same if S is empty
            Funny_Stuff(B,L,N,S(S'First+1 .. S'Last), T(T'First+1..T'Last)); --
         exception
            when Constraint_Error =>
               B   := N;
               L   := N;
         end;
      end if;
   exception
      when Constraint_Error => null;
   end Funny_Stuff;

   Buffer: Unbounded_String := +"";
   Longest: Unbounded_String := +"";
   Next: Unbounded_String;

begin
   while True loop
      Next := + Ada.Text_IO.Get_Line;
      Funny_Stuff(Buffer, Longest, Next, -Longest, -Next);
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
