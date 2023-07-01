open GMain

let window = GWindow.window ~border_width:2 ()
let vbox = GPack.vbox ~packing:window#add ()
let label = GMisc.label ~text:"There have been no clicks yet" ~packing:vbox#pack ()
let button = GButton.button ~label:"click me" ~packing:vbox#pack ()

let () =
  window#event#connect#delete ~callback:(fun _ -> true);
  window#connect#destroy ~callback:Main.quit;
  button#connect#clicked ~callback:window#destroy;
  window#show ();
  Main.main ()
