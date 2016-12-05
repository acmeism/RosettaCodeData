import gtk2

var
  win = windowNew WINDOW_TOPLEVEL
  button = buttonNew "Click me"
  label = labelNew  "There have been no clicks yet"
  vbox = vboxNew(true, 1)
  counter = 0

proc clickedMe(o: var PButton, l: PLabel) =
  inc counter
  l.setText "You clicked me " & $counter & " times"

nim_init()
win.setTitle "Click me"
vbox.add label
vbox.add button
win.add vbox
discard win.signal_connect("delete-event", SignalFunc mainQuit, nil)
discard button.signal_connect("clicked", SignalFunc clickedMe, label)
win.showAll()
main()
