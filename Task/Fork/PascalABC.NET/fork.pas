uses System.Threading;

procedure Fork;
begin
  WriteLn('Spawned Thread');
end;

begin
  var t := new Thread(ThreadStart(Fork));
  t.Start;

  WriteLn('Main Thread');
  t.Join;
  Readln;
end.
