let () =
  let action () = exit 0 in
  let main_widget = Tk.openTk () in
  let bouton_press =
    Button.create main_widget ~text:"Goodbye, World" ~command:action in
  Tk.pack [bouton_press];
  Tk.mainLoop();;
