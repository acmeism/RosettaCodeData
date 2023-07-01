type doorState=Open|Closed
let flip=function Open->Closed |_->Open
let Doors=Array.create 100 Closed
for n in 1..100 do {n-1..n..99}|>Seq.iter(fun n->Doors[n]<-flip Doors[n])
Doors|>Array.iteri(fun n g->if g=Open then printf "%d " (n+1)); printfn ""
