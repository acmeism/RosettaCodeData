let quibble list =
    let rec inner = function
        | [] -> ""
        | [x] -> x
        | [x;y] -> sprintf "%s and %s" x y
        | h::t -> sprintf "%s, %s" h (inner t)
    sprintf "{%s}" (inner list)

// test interactively
quibble []
quibble ["ABC"]
quibble ["ABC"; "DEF"]
quibble ["ABC"; "DEF"; "G"]
quibble ["ABC"; "DEF"; "G"; "H"]
