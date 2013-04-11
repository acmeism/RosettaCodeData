generic
   with procedure Put_Line(Line: String);
package Word_Wrap is

   type Basic(Length_Of_Output_Line: Positive) is tagged private;

   procedure Push_Word(State: in out Basic; Word: String);
   procedure New_Paragraph(State: in out Basic);
   procedure Finish(State: in out Basic);

private
   type Basic(Length_Of_Output_Line: Positive) is tagged record
      Line: String(1 .. Length_Of_Output_Line);
      Size: Natural := 0; -- Line(1 .. Size) is relevant
      Top_Of_Paragraph: Boolean := True;
   end record;

end Word_Wrap;
