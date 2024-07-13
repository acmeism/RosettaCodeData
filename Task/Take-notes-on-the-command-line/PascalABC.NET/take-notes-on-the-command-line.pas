begin
  //Print(ParamStr(1));
  if ParamCount = 0 then
    System.IO.File.ReadAllText('Notes.txt').Print
  else begin
    System.IO.File.AppendAllText('Notes.txt',DateTime.Now.ToString);
    var s := (1..ParamCount).Select(i -> ParamStr(i)+NewLine).JoinToString;
    s := #9 + NewLine + s;
    System.IO.File.AppendAllText('Notes.txt',s);
  end;
end.
