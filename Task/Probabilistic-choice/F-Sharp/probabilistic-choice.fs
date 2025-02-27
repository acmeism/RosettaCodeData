// Probabilistic choice. Nigel Galloway: November 15th., 2024
type items=Aleph|Beth|Gimel|Daleth|He|Waw|Zayin|Heth
let item=function n when n<5544 ->Aleph
                 |n when n<10164->Beth
                 |n when n<14124->Gimel
                 |n when n<17589->Daleth
                 |n when n<20669->He
                 |n when n<23441->Waw
                 |n when n<25961->Zayin
                 |_->Heth
let R=System.Random()
let expected=function Aleph ->1000000/5
                     |Beth  ->1000000/6
                     |Gimel ->1000000/7
                     |Daleth->1000000/8
                     |He    ->1000000/9
                     |Waw   ->1000000/10
                     |Zayin ->1000000/11
                     |Heth  ->(1000000*1759)/27720
Seq.init 1000000 (fun _->R.Next(0,27720))|>Seq.countBy item|>Seq.iter(fun(n,g)->printfn $"item={n} count={g} expected={expected n}")
