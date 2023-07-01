let ffr,ffs=fF 960
ffr|>Seq.take 10|>Seq.iter(printf "%d "); printfn ""

let N=Array.concat [|ffs;(Array.take 40 ffr)|] in printfn "Unique values=%d Minimum value=%d Maximum Value=%d" ((Array.distinct N).Length)(Array.min N)(Array.max N)
