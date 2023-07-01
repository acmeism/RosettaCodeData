let Q=Array.zeroCreate<int>10 in fQ Q; printfn "%A" Q
let Q=Array.zeroCreate<int>1000 in fQ Q; printfn "%d" (Array.last Q)
