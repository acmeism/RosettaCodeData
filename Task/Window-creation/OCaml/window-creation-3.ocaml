open GMain

let window = GWindow.window ~border_width:2 ()
let button = GButton.button ~label:"Hello World" ~packing:window#add ()

let () =
  window#event#connect#delete  ~callback:(fun _ -> true);
  window#connect#destroy ~callback:Main.quit;
  button#connect#clicked ~callback:window#destroy;
  window#show ();
  Main.main ()
