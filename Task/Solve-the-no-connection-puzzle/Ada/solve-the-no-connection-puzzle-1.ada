With
Ada.Text_IO,
Connection_Types,
Connection_Combinations;

procedure main is
   Result : Connection_Types.Partial_Board renames Connection_Combinations;
begin
   Ada.Text_IO.Put_Line( Connection_Types.Image(Result) );
end;
