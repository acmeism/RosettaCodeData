let inline cmp x y = if x < y then -1 else if x = y then 0 else 1
let before (s1 : seq<'a>) (s2 : seq<'a>) = (Seq.compareWith cmp s1 s2) < 0

[
    ([0], []);
    ([], []);
    ([], [0]);
    ([-1], [0]);
    ([0], [0]);
    ([0], [-1]);
    ([0], [0; -1]);
    ([0], [0; 0]);
    ([0], [0; 1]);
    ([0; -1], [0]);
    ([0; 0], [0]);
    ([0; 0], [1]);
]
|> List.iter (fun (x, y) -> printf "%A %s %A\n" x (if before x y then "< " else ">=") y)
