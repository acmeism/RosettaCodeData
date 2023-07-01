with Ada.Text_IO, Word_Wrap, Ada.Strings.Unbounded, Ada.Command_Line;

procedure Wrap is

   use  Ada.Strings.Unbounded;

   Line: Unbounded_String;
   Word: Unbounded_String;

   function "+"(S: String) return Unbounded_String renames To_Unbounded_String;
   function "-"(U: Unbounded_String) return String renames To_String;

   package IO renames Ada.Text_IO;

   procedure Split(S: Unbounded_String; First, Rest: out Unbounded_String) is

      function Skip_Leading_Spaces(S: String) return String is
      begin
         if S="" then return "";
         elsif S(S'First) = ' ' then return S(S'First+1 .. S'Last);
         else return S;
         end if;
      end Skip_Leading_Spaces;

      Str: String := Skip_Leading_Spaces(-S);
      I: Positive := Str'First;
      J: Natural;
   begin
      -- read nonspaces for First output param
      J := I-1;
      while J < Str'Last and then Str(J+1) /= ' ' loop
         J := J + 1;
      end loop;
      First := + Str(I .. J);

      -- write output param Rest
      Rest  := + Skip_Leading_Spaces(Str(J+1 .. Str'Last));
   end Split;

   procedure Print(S: String) is
   begin
      IO.Put_Line(S);
   end Print;

   package WW is new Word_Wrap(Print);

   Wrapper: WW.Basic(Integer'Value(Ada.Command_Line.Argument(1)));

begin
   while not IO.End_Of_File loop
      Line := +IO.Get_Line;
      if Line = +"" then
         Wrapper.New_Paragraph;
         Line := +IO.Get_Line;
      end if;
      while Line /= +"" loop
         Split(Line, First => Word, Rest => Line);
         Wrapper.Push_Word(-Word);
      end loop;
   end loop;
   Wrapper.Finish;
end Wrap;
