module Entry = struct
  type t = { word : string ; min : int }
  let compare e1 e2 =
    let n1 = length e1.word in
    if n1 < e2.min || n1 > length e2.word then
      compare e1.word e2.word
    else
      compare (sub e1.word 0 n1) (sub e2.word 0 n1)
end

module Table = Set.Make(Entry)
