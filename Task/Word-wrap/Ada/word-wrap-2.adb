package body Word_Wrap is

   procedure Push_Word(State: in out Basic; Word: String) is
   begin
      if Word'Length + State.Size >= State.Length_Of_Output_Line then
         Put_Line(State.Line(1 .. State.Size));
         State.Line(1 .. Word'Length) := Word; -- may raise CE if Word too long
         State.Size := Word'Length;
      elsif State.Size > 0 then
         State.Line(State.Size+1 .. State.Size+1+Word'Length) := ' ' & Word;
         State.Size := State.Size + 1 + Word'Length;
      else
         State.Line(1 .. Word'Length) := Word;
         State.Size := Word'Length;
      end if;
      State.Top_Of_Paragraph := False;
   end Push_Word;

   procedure New_Paragraph(State: in out Basic) is
   begin
      Finish(State);
      if not State.Top_Of_Paragraph then
         Put_Line("");
         State.Top_Of_Paragraph := True;
      end if;
   end New_Paragraph;

   procedure Finish(State: in out Basic) is
   begin
      if State.Size > 0 then
         Put_Line(State.Line(1 .. State.Size));
         State.Size := 0;
      end if;
   end Finish;

end Word_Wrap;
