let q=Seq.item 749 (randLS 42)
for n in [0..41] do (for g in [0..41] do printf "%3d" q.[n,g]); printfn ""
