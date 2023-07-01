module caesar =
    open System

    let private cipher n s =
        let shift c =
            if Char.IsLetter c then
                let a = (if Char.IsLower c then 'a' else 'A') |> int
                (int c - a + n) % 26 + a |> char
            else c
        String.map shift s

    let encrypt n = cipher n
    let decrypt n = cipher (26 - n)
