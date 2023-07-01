fun takeWhileEq ([], _) = []
  | takeWhileEq (_, []) = []
  | takeWhileEq (x :: xs, y :: ys) =
      if x = y then x :: takeWhileEq (xs, ys) else []

fun commonPath sep =
  let
    val commonInit = fn [] => [] | x :: xs => foldl takeWhileEq x xs
    and split = String.fields (fn c => c = sep)
    and join = String.concatWith (str sep)
  in
    join o commonInit o map split
  end

val paths = [
  "/home/user1/tmp/coverage/test",
  "/home/user1/tmp/covert/operator",
  "/home/user1/tmp/coven/members"
]

val () = print (commonPath #"/" paths ^ "\n")
