open Printf

let create_logger () =
  def log(text) & logs(l) =
      printf "Logged: %s\n%!" text;
      logs((text, Unix.gettimeofday ())::l) & reply to log

   or search(text) & logs(l) =
      logs(l) & reply List.filter (fun (line, _) -> line = text) l to search
  in
    spawn logs([]);
    (log, search)

def wait() & finished() = reply to wait

let register name service = Join.Ns.register Join.Ns.here name service

let () =
  let log, search = create_logger () in
    register "log" log;
    register "search" search;
    Join.Site.listen (Unix.ADDR_INET (Join.Site.get_local_addr(), 12345));
    wait ()
