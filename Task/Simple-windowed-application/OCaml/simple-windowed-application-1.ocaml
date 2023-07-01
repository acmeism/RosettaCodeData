#directory "+labltk"
#load "labltk.cma"

let () =
  let top = Tk.openTk() in
  Wm.title_set top "Tk-OCaml Example";
  let label = Label.create ~text:"There have been no clicks yet" top in
  let b =
    Button.create
        ~text:"click me"
        ~command:(fun () -> Tk.closeTk (); exit 0)
        top
  in
  Tk.pack [Tk.coe label; Tk.coe b];
  Tk.mainLoop ();
;;
