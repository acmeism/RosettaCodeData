procedure OnElapsed(sender: object; eventArgs: System.Timers.ElapsedEventArgs);
begin
  Writeln(eventArgs.SignalTime);
  system.Timers.Timer(sender).Stop;
end;

begin
  var timer := System.Timers.Timer.Create(1000);
  timer.Elapsed += OnElapsed;
  Writeln(DateTime.Now);
  timer.Start;
  Console.ReadLine;
end.
