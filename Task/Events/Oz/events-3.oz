declare
  MyPort
in
  thread
     MyStream
  in
     {NewPort ?MyStream ?MyPort}
     {System.showInfo "[2] Waiting for event..."}
     for Event in MyStream do
	{System.showInfo "[2] Received event."}
	{System.showInfo "[2] Waiting for event again..."}
     end
  end

  for do
     {System.showInfo "[1] Waiting 1 second..."}
     {Delay 1000}
     {System.showInfo "[1] Signaling event."}
     {Port.send MyPort unit}
  end
