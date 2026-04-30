with Ada.Text_IO;

procedure Odd_Word_Problem is

   use Ada.Text_IO; -- Get, Put, and Look_Ahead

   function Current return Character is
      -- reads the current input character, without consuming it
      End_Of_Line: Boolean;
      C: Character;
   begin
      Look_Ahead(C, End_Of_Line);
      if End_Of_Line then
         raise Constraint_Error with "end of line before the terminating '.'";
      end if;
      return C;
   end Current;

   procedure Skip is
      -- consumes the current input character
      C: Character;
   begin
      Get(C);
   end Skip;

   function Is_Alpha(Ch: Character) return Boolean is
   begin
      return (Ch in  'a' .. 'z') or (Ch in 'A' .. 'Z');
   end Is_Alpha;

   procedure Odd_Word(C: Character) is
   begin
      if Is_Alpha(C) then
         Skip;
         Odd_Word(Current);
         Put(C);
      end if;
   end Odd_Word;

begin -- Odd_Word_Problem
   Put(Current);
   while Is_Alpha(Current) loop -- read an even word
      Skip;
      Put(Current);
   end loop;
   if Current /= '.' then -- read an odd word
      Skip;
      Odd_Word(Current);
      Put(Current);
      if Current /= '.' then -- read the remaining words
         Skip;
         Odd_Word_Problem;
      end if;
   end if;
end Odd_Word_Problem;
