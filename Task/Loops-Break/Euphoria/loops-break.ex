integer i
while 1 do
    i = rand(20) - 1
    printf(1, "%g ", {i})
    if i = 10 then
        exit
    end if
    printf(1, "%g ", {rand(20)-1})
end while
