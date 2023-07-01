type door = Open | Closed    (* human readable code *)

let flipdoor = function Open -> Closed | Closed -> Open

let string_of_door =
  function Open -> "is open." | Closed -> "is closed."

let printdoors ls =
  let f i d = Printf.printf "Door %i %s\n" (i + 1) (string_of_door d)
  in List.iteri f ls

let outerlim = 100
let innerlim = 100

let rec outer cnt accu =
  let rec inner i door = match i > innerlim with (* define inner loop *)
    | true  -> door
    | false -> inner (i + 1) (if (cnt mod i) = 0 then flipdoor door else door)
  in (* define and do outer loop *)
  match cnt > outerlim with
  | true  -> List.rev accu
  | false -> outer  (cnt + 1)  (inner 1 Closed :: accu) (* generate new entries with inner *)

let () = printdoors (outer 1 [])
