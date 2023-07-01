local
  fun check (c, p as (m, n)) =
    if Char.isDigit c then
      (not m, (if m then 3 * (ord c - 48) else ord c - 48) + n)
    else
      p
in
  fun checkISBN s =
    Int.rem (#2 (CharVector.foldl check (false, 0) s), 10) = 0
end

val test = ["978-1734314502", "978-1734314509", "978-1788399081", "978-1788399083"]
val () = (print
          o concat
          o map (fn s => s ^ (if checkISBN s then ": good\n" else ": bad\n"))) test
