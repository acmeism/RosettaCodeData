let do_while f p =
  let rec loop() =
    f();
    if p() then loop()
  in
  loop()
(** val do_while : (unit -> 'a) -> (unit -> bool) -> unit *)
