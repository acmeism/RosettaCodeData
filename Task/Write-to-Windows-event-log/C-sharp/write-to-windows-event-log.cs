using System.Diagnostics;

namespace RC
{
  internal class Program
  {
    public static void Main()
    {
      string sSource  = "Sample App";
      string sLog     = "Application";
      string sEvent   = "Hello from RC!";

      if (!EventLog.SourceExists(sSource))
        EventLog.CreateEventSource(sSource, sLog);

      EventLog.WriteEntry(sSource, sEvent);
      EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Information);
    }
  }
}
