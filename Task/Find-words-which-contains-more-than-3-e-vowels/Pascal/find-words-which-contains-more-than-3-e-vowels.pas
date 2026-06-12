program EWords;
var
   FileVar: Text;
   Line: string[255];
   I: Integer;
   E: Integer;
   OK: Boolean;
begin
   Assign(FileVar, 'unixdict.txt');
   Reset(FileVar);

   while not Eof(FileVar) do
   begin
      ReadLn(FileVar, Line);
      E := 0;
      OK := True;
      for I := 1 to Length(Line) do
      begin
         OK := OK and (Pos(Line[I], 'aiou') = 0);
         if Line[I] = 'e' then E := E + 1
      end;
      if OK and (E > 3) then
      begin
         Write(Line);
         WriteLn;
      end
   end
end.
