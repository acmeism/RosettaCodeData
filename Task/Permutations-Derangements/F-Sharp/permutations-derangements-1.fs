// Generate derangements. Nigel Galloway: July 9th., 2019
let derange n=
  let fG n i g=let e=Array.copy n in e.[i]<-n.[g]; e.[g]<-n.[i]; e
  let rec derange n g α=seq{
    match (α>0,n&&&(1<<<α)=0) with
     (true,true)->for i in [0..α-1] do if n&&&(1<<<i)=0 then let g=(fG g α i) in yield! derange (n+(1<<<i)) g (α-1); yield! derange n g (α-1)
    |(true,false)->yield! derange n g (α-1)
    |(false,false)->yield g
    |_->()}
  derange 0 [|1..n|] (n-1)
