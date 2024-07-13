(* these type decorations are optional, you could just as well put:
  fun isValidISBN s =
*)
fun isValidISBN (s : string) : bool =
  let
    val digits = List.filter Char.isDigit (explode s)
    val nums = map (fn x => ord x - ord #"0") digits
    val len = length nums
    fun sumISBN [] = raise Domain
      | sumISBN [x] = x
      | sumISBN (x1::x2::xs) = x1 + 3*x2 + sumISBN xs
  in
    len = 13 andalso sumISBN nums mod 10 = 0
  end

val test = ["978-1734314502", "978-1734314509",
            "978-1788399081", "978-1788399083"]

fun printTest (s : string) : unit =
  (print s; print (if isValidISBN s then ": good\n" else ": bad\n"))

fun main () = app printTest test
