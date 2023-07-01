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
      C:= T(T'First); -- (1) raises Constraint_Error if T is empty
      begin
	 C := S(S'First); -- (2) raises Constraint_Error if S is empty
	   -- at this point, we know that neither S nor T are empty
         Funny_Stuff(B,L,N,S(S'First+1 .. S'Last), T(T'First+1..T'Last));
      exception
         when Constraint_Error => -- come from (2), S is empty, T is not empty!
	    B   := N;
	    L   := N;
      end;
   exception
      when Constraint_Error => -- come from (1), T is empty
	 begin
	    C := S(S'First); -- (3) raises Constraint_Error if S is empty
	    -- at this point, we know that T is empty and S isn't
	    null;
	exception
	    when Constraint_Error => -- come from (3); both S and T are empty
	    B := B & Separator & N;
	end;
   end Funny_Stuff;

   Buffer: Unbounded_String := +"";
   Longest: Unbounded_String := +"";
   Next: Unbounded_String;

begin
   while True loop
      Next := + Ada.Text_IO.Get_Line;
        -- (4) raises exception when trying to read beyond end of file
      Funny_Stuff(Buffer, Longest, Next, -Longest, -Next);
   end loop;
exception
   when others => -- come from (4)
      for I in To_String(Buffer)'Range loop
         if To_String(Buffer)(I) = Separator then
            Ada.Text_IO.New_Line;
         else
            Ada.Text_IO.Put(To_String(Buffer)(I));
         end if;
      end loop;
end Longest_String_Challenge;
