fun isOrdered s =
  let
    fun loop (i, c) =
      let
        val c' = String.sub (s, i)
      in
        c <= c' andalso loop (i + 1, c')
      end
      handle Subscript => true
  in
    loop (0, #"\^@")
  end

fun longestOrdereds (s, prev as (len, lst)) =
  let
    val len' = size s
  in
    if len' >= len andalso isOrdered s then
      if len' = len then (len, s :: lst) else (len', [s])
    else
      prev
  end

val () = print ((String.concatWith " "
                 o #2
                 o foldr longestOrdereds (0, [])
                 o String.tokens Char.isSpace
                 o TextIO.inputAll) TextIO.stdIn ^ "\n")
