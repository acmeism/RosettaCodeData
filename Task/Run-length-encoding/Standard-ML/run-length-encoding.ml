fun encode str =
  let
    fun aux (sub, acc) =
      case Substring.getc sub
       of NONE           => rev acc
        | SOME (x, sub') =>
            let
              val (y, z) = Substring.splitl (fn c => c = x) sub'
            in
              aux (z, (x, Substring.size y + 1) :: acc)
            end
  in
    aux (Substring.full str, [])
  end

fun decode lst =
  concat (map (fn (c,n) => implode (List.tabulate (n, fn _ => c))) lst)
