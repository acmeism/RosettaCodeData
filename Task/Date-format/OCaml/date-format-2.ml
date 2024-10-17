let months = [| "January"; "February"; "March"; "April"; "May"; "June";
      "July"; "August"; "September"; "October"; "November"; "December" |]

let days = [| "Sunday"; "Monday"; "Tuesday";  (* Sunday is 0 *)
      "Wednesday"; "Thursday"; "Friday"; "Saturday" |]

# Printf.sprintf "%s, %s %d, %d"
      days.(gmt.tm_wday)
      months.(gmt.tm_mon)
      gmt.tm_mday
      (1900 + gmt.tm_year) ;;
- : string = "Friday, August 29, 2008"
