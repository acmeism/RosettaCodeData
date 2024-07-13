uses System.Diagnostics;

begin
  if not EventLog.SourceExists('MyApp') then
    EventLog.CreateEventSource('MyApp', 'Application');
  EventLog.WriteEntry('MyApp', 'Hello from PABC!');
end.
