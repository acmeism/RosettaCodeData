let () =
  let app = SFRenderWindow.make (640, 480) "OCaml-SFML Windowing" in

  let rec loop () =
    let continue =
      match SFRenderWindow.pollEvent app with
      | Some SFEvent.Closed -> false
      | _ -> true
    in
    SFRenderWindow.clear app SFColor.black;
    SFRenderWindow.display app;
    if continue then loop ()
  in
  loop ()
