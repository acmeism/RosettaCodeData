let is_palindrome s =
    let l = String.length s in
    let rec comp n =
        n = 0 || (s.[l-n] = s.[n-1] && comp (n-1)) in
    comp (l / 2)
