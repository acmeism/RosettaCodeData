let delete_event evt = false

let destroy () = GMain.Main.quit ()

let main () =
  let window = GWindow.window in
  let _ = window#set_title "Goodbye, World" in
  let _ = window#event#connect#delete ~callback:delete_event in
  let _ = window#connect#destroy ~callback:destroy in
  let _ = window#show () in
  GMain.Main.main ()
;;

let _ = main () ;;
