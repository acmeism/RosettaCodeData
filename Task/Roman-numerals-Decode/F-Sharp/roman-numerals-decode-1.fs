let decimal_of_roman roman =
    let rec convert arabic lastval = function
        | head::tail ->
            let n = match head with
                    | 'M' | 'm' -> 1000
                    | 'D' | 'd' -> 500
                    | 'C' | 'c' -> 100
                    | 'L' | 'l' -> 50
                    | 'X' | 'x' -> 10
                    | 'V' | 'v' -> 5
                    | 'I' | 'i' -> 1
                    | _ -> 0
            let op = if n > lastval then (-) else (+)
            convert (op arabic lastval) n tail
        | _ -> arabic + lastval
    convert 0 0 (Seq.toList roman)
;;
