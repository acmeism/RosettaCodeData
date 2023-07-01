let rec printI2α=function |0->printf "naught->"; printI2α 6
                          |4->printfn "four is magic"
                          |n when n<0->let g = I2α -n "minus " in printf "%s->" g; printI2α (g.Length)
                          |n         ->let g = I2α n "" in printf "%s->" g; printI2α (g.Length)
let N=System.Random()
List.init 25 (fun _->N.Next 999999) |> List.iter printI2α
