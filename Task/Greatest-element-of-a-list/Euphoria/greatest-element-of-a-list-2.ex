function get_biggest(sequence s)
    object biggun
    biggun = s[1]
    for i = 2 to length(s) do
        if compare(s[i], biggun) > 0 then
            biggun = s[i]
        end if
    end for
    return biggun
end function

constant numbers = {1,1234,62,234,12,34,6}
printf(1,"%d\n",get_biggest(numbers))

constant animals = {"ant", "antelope", "dog", "cat", "cow", "wolf", "wolverine", "aardvark"}
printf(1,"%s\n",{get_biggest(animals)})
