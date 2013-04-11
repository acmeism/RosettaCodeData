declare
  fun {NewEvent}
     {NewCell _}
  end

  proc {SignalEvent Event}
     @Event = unit
  end

  proc {ResetEvent Event}
     Event := _
  end

  proc {WaitEvent Event}
     {Wait @Event}
  end

  E = {NewEvent}
in
  thread
     {System.showInfo "[2] Waiting for event..."}
     {WaitEvent E}
     {System.showInfo "[2] Received event."}
  end

  {System.showInfo "[1] Waiting 1 second..."}
  {Delay 1000}
  {System.showInfo "[1] Signaling event."}
  {SignalEvent E}
