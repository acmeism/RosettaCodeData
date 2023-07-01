let rec hailstone n = seq {
  match n with
  | 1                -> yield 1
  | n when n % 2 = 0 -> yield n; yield! hailstone (n / 2)
  | n                -> yield n; yield! hailstone (n * 3 + 1)
}

let hailstone27 = hailstone 27 |> Array.ofSeq
assert (Array.length hailstone27 = 112)
assert (hailstone27.[..3] = [|27;82;41;124|])
assert (hailstone27.[108..] = [|8;4;2;1|])

let maxLen, maxI = Seq.max <| seq { for i in 1..99999 -> Seq.length (hailstone i), i}
printfn "Maximum length %d was found for hailstone(%d)" maxLen maxI
