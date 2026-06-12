let rec wait n = match n with
        | 0 -> ()
        | n -> Sys.command "sleep 1"; wait (n - 1);;

Printf.printf "Please enter a number of seconds\n";;
let time = read_int ();;

Printf.printf "Please enter a file name\n";;
let fileName = (read_line ()) ^ ".mp3";;

wait time;;
Sys.command ("mpg123 " ^ fileName);;
