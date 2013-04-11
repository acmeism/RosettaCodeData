declare
  E
in
  thread
     {System.showInfo "[2] Waiting for event..."}
     {Wait E}
     {System.showInfo "[2] Received event."}
  end

  {System.showInfo "[1] Waiting 1 second..."}
  {Delay 1000}
  {System.showInfo "[1] Signaling event."}
  E = unit
