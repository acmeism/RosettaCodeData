let mutable nm=uint64(1)
let mutable dm=uint64(1)
let mutable a=uint64(1)

printf "1, "
for i = 2 to 15 do
    nm<-uint64(1)
    dm<-uint64(1)
    for k = 2 to i do
        nm <-uint64( uint64(nm) * (uint64(i)+uint64(k)))
        dm <-uint64( uint64(dm) * uint64(k))
    let a = uint64(uint64(nm)/uint64(dm))
    printf "%u"a
    if(i<>15) then
        printf ", "
