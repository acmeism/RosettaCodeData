fun assert cond =
  if cond then () else raise Fail "assert"

val () = assert (x = 42)
