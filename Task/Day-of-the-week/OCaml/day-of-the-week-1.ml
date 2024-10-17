#load "unix.cma"
open Unix

try
  for i = 2008 to 2121 do
    (* I'm lazy so we'll just borrow the current time
       instead of having to set all the fields explicitly *)
    let mytime = { (localtime (time ())) with
                   tm_year  = i - 1900;
                   tm_mon   = 11;
                   tm_mday  = 25 } in
    try
      let _, mytime = mktime mytime in
        if mytime.tm_wday = 0 then
          Printf.printf "25 December %d is Sunday\n" i
    with e ->
      Printf.printf "%d is the last year we can specify\n" (i-1);
      raise e
  done
with _ -> ()
