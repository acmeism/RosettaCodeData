let mutable a=0
let mutable b=0
let mutable c=0
let mutable d=0
let mutable e=0
let mutable f=0
for i=1 to 20000 do
    b <- 0
    f <- i/2
    for j=1 to f do
        if i%j=0 then
           b <- b+i
    if b<i then
       c <- c+1
    if b=i then
       d <- d+1
    if b>i then
       e <- e+1
printfn " deficient %i"c
printfn "perfect %i"d
printfn "abundant %i"e
