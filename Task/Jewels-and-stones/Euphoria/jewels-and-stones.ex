function number_of(object jewels, object stones) -- why limit ourselves to strings?
integer ct = 0
    for i = 1 to length(stones) do
        ct += find(stones[i],jewels) != 0
    end for
    return ct
end function

? number_of("aA","aAAbbbb")
? number_of("z","ZZ")
? number_of({1,"Boo",3},{1,2,3,'A',"Boo",3}) -- might as well send a list of things to find, not just one!
