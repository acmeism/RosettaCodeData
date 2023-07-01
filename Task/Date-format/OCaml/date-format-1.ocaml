# #load "unix.cma";;
# open Unix;;

# let t = time() ;;
val t : float = 1219997516.

# let gmt = gmtime t ;;
val gmt : Unix.tm =
  {tm_sec = 56; tm_min = 11; tm_hour = 8; tm_mday = 29; tm_mon = 7;
   tm_year = 108; tm_wday = 5; tm_yday = 241; tm_isdst = false}

# Printf.sprintf "%d-%02d-%02d" (1900 + gmt.tm_year) (1 + gmt.tm_mon) gmt.tm_mday ;;
- : string = "2008-08-29"
