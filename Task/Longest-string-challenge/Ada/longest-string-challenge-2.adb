with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO, Ada.Characters.Latin_1;

procedure Longest_String_Challenge is
   function "+"(S: String) return Unbounded_String renames To_Unbounded_String;
   Separator: constant Character := Ada.Characters.Latin_1.NUL;

   procedure Funny_Stuff(B, L: in out Unbounded_String; N: Unbounded_String) is
      -- B holds a list of all longest strings, separated by Separator
      -- L holds longest string so far
      -- N is the next string to be considered
      Nat: Natural;
   begin
      Nat := Length(N) - Length(L);
        -- (1) this raises exception if L longer then N
      declare
         Pos: Positive;
      begin
         Pos := Nat; -- (2) this raises exception if L at least as long as N
                     -- at this point, we know N is longer then L
         B   := N;
         L   := N;
      exception
         when Constraint_Error -- come from (2)
            -- at this point, we know L and N are of the same length
            => B := B & Separator & N; -- add N to the set of solutions
      end;
   exception
      when Constraint_Error => null; -- come from (1)
        -- at this point, we know L is longer then N
   end Funny_Stuff;

   Buffer: Unbounded_String := +"";
   Longest: Unbounded_String := +"";
   Next: Unbounded_String;

begin
   while True loop
      Next := + Ada.Text_IO.Get_Line;
        -- (3) raises exception when trying to read beyond the end of file
      Funny_Stuff(Buffer, Longest, Next);
   end loop;
exception
   when others => -- come from (3)
      for I in To_String(Buffer)'Range loop
         if To_String(Buffer)(I) = Separator then
            Ada.Text_IO.New_Line;
         else
            Ada.Text_IO.Put(To_String(Buffer)(I));
         end if;
      end loop;
end Longest_String_Challenge;
