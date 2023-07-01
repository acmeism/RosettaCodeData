function shuffle(sequence s)
    object temp
    integer j
    for i = length(s) to 1 by -1 do
        j = rand(i)
        if i != j then
            temp = s[i]
            s[i] = s[j]
            s[j] = temp
        end if
    end for
    return s
end function

function inOrder(sequence s)
    for i = 1 to length(s)-1 do
        if compare(s[i],s[i+1]) > 0 then
            return 0
        end if
    end for
    return 1
end function

function bogosort(sequence s)
    while not inOrder(s) do
        ? s
        s = shuffle(s)
    end while
    return s
end function

? bogosort(shuffle({1,2,3,4,5,6}))
