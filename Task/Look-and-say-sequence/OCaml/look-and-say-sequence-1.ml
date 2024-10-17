let rec seeAndSay = function
  | [], nys -> List.rev nys
  | x::xs, [] -> seeAndSay(xs, [x; 1])
  | x::xs, y::n::nys when x=y -> seeAndSay(xs, y::1+n::nys)
  | x::xs, nys -> seeAndSay(xs, x::1::nys)
