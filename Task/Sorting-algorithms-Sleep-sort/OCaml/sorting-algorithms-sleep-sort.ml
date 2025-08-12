#directory "+unix";;
#directory "+threads";;
#load "unix.cma";;
#load "threads.cma";;

List.iter Thread.join (List.map (fun x -> Thread.create (fun x -> Thread.delay (float_of_int x);Printf.printf "%i\n%!" x) x;) (List.map int_of_string (List.tl (Array.to_list Sys.argv))));;
