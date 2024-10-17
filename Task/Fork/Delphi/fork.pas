program Fork_app;

{$APPTYPE CONSOLE}

uses
  System.Threading;

procedure Fork;
begin
  Writeln('Spawned Thread');
end;

var
  t: ITask;

begin
  t := TTask.Run(fork);

  Writeln('Main Thread');

  TTask.WaitForAll(t);
  Readln;
end.
