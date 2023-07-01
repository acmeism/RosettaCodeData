open Printf

let ns_there = Join.Ns.there (Unix.ADDR_INET (Join.Site.get_local_addr(), 12345))

let lookup name = Join.Ns.lookup ns_there name

let log : string -> unit = lookup "log"
let search : string -> (string * float) list = lookup "search"

let find txt =
  printf "Looking for %s...\n" txt;
  List.iter (fun (line, time) ->
               printf "Found: '%s' at t = %f\n%!" (String.escaped line) time)
    (search txt)

let () =
  log "bar";
  find "foo";
  log "foo";
  log "shoe";
  find "foo"
