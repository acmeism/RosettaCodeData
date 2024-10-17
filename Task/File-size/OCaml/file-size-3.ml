#load "unix.cma" ;;
open Unix ;;
Printf.printf "%d\n" (stat "input.txt").st_size ;;
Printf.printf "%d\n" (stat "/input.txt").st_size ;;
