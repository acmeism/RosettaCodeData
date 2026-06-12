// Create a geoHash String. Nigel Galloway: June 26th., 2020
let fG n g=Seq.unfold(fun(α,β)->let τ=(α+β)/2.0 in Some(if τ>g then (0,(α,τ)) else (1,(τ,b)))) n
let fLat, fLon = fG (-90.0,90.0), fG (-180.0,180.0)
let fN n g z=Seq.zip(fLat n)(fLon g)|>Seq.collect(fun(n,g)->seq{yield g;yield n})|>Seq.take(z*5)|>Seq.splitInto z
let fI=Array.fold2 (fun Σ α β->Σ+α*β) 0  [|16; 8; 4; 2; 1|]
let geoHash n g z=let N="0123456789bcdefghjkmnpqrstuvwxyz" in [|for τ in fN n g z do  yield N.[fI τ]|] |> System.String
printfn "%s\n%s\n%s" (geoHash 51.433718 -0.214126 2) (geoHash 51.433718 -0.214126 9) (geoHash 57.64911 10.40744 11)
