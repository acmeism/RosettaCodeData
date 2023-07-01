open System
open System.Text.RegularExpressions

let encode data =
    // encodeData : seq<'T> -> seq<int * 'T> i.e. Takes a sequence of 'T types and return a sequence of tuples containing the run length and an instance of 'T.
    let rec encodeData input =
        seq { if not (Seq.isEmpty input) then
                 let head = Seq.head input
                 let runLength = Seq.length (Seq.takeWhile ((=) head) input)
                 yield runLength, head
                 yield! encodeData (Seq.skip runLength input) }

    encodeData data |> Seq.fold(fun acc (len, d) -> acc + len.ToString() + d.ToString()) ""

let decode str =
    [ for m in Regex.Matches(str, "(\d+)(.)") -> m ]
    |> List.map (fun m -> Int32.Parse(m.Groups.[1].Value), m.Groups.[2].Value)
    |> List.fold (fun acc (len, s) -> acc + String.replicate len s) ""
