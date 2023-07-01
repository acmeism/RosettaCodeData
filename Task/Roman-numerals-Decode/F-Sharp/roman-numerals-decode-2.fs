let decimal_of_roman roman =
    let convert (arabic,lastval) c =
        let n = match c with
                | 'M' | 'm' -> 1000
                | 'D' | 'd' -> 500
                | 'C' | 'c' -> 100
                | 'L' | 'l' -> 50
                | 'X' | 'x' -> 10
                | 'V' | 'v' -> 5
                | 'I' | 'i' -> 1
                | _ -> 0
        let op = if n > lastval then (-) else (+)
        (op arabic lastval, n)
    let (arabic, lastval) = Seq.fold convert (0,0) roman
    arabic + lastval
;;
