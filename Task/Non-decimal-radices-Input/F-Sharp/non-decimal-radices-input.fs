let value = "100"
let fromBases = [ 2; 8; 10; 16 ]
let values = Seq.initInfinite (fun i -> value)
Seq.zip fromBases (Seq.zip values fromBases |> Seq.map (System.Convert.ToInt32))
|> Seq.iter (
    fun (fromBase, valueFromBaseX) ->
        printfn "%s in base %i is %i in base 10" value fromBase valueFromBaseX)
