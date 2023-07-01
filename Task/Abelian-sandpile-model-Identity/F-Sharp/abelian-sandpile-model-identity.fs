let s1=Sandpile(3,3,[|1;2;0;2;1;1;0;1;3|])
let s2=Sandpile(3,3,[|2;1;3;1;0;1;0;1;0|])
printfn "%s\n" ((s1+s2).toS)
printfn "%s\n" ((s2+s1).toS);;
printfn "%s\n" ((s1+s1).toS)
printfn "%s\n" ((s2+s2).toS);;
printfn "%s\n" (Sandpile(3,3,[|4;3;3;3;1;2;0;2;3|])).toS;;
let s3=Sandpile(3,3,(Array.create 9 3))
let s3_id=Sandpile(3,3,[|2;1;2;1;0;1;2;1;2|])
printfn "%s\n" (s3+s3_id).toS
printfn "%s\n" (s3_id+s3_id).toS
//Add together 2 5x5 Sandpiles
let e1=Array.zeroCreate<int> 25 in e1.[12]<-6
let e2=Array.zeroCreate<int> 25 in e2.[12]<-16
printfn "%s\n" ((Sandpile(5,5,e1)+Sandpile(5,5,e2)).toS)
