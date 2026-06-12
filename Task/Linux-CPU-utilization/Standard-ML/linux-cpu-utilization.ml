val delay = Time.fromSeconds 2

fun p100 (part, full) = (200 * part div full + 1) div 2

val read1stLine =
  (fn strm => TextIO.inputLine strm before TextIO.closeIn strm) o TextIO.openIn

val getColumns = Option.map (String.tokens Char.isSpace) o read1stLine

fun cpuStat list = (List.nth (list, 3), foldl op+ 0 list)

fun printStat (list, (idle, total)) =
  let
    val newStat as (idle', total') = cpuStat (map (valOf o Int.fromString) list)
  in
    print (Int.toString (100 - p100 (idle' - idle, total' - total)) ^ "%\n");
    OS.Process.sleep delay;
    newStat
  end

fun mainLoop prev =
  case getColumns "/proc/stat" of
    SOME ("cpu" :: list) => mainLoop (printStat (list, prev))
  | _ => ()

val () = mainLoop (0, 0)
