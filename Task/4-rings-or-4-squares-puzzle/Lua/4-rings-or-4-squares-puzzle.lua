function valid(unique,needle,haystack)
    if unique then
        for _,value in pairs(haystack) do
            if needle == value then
                return false
            end
        end
    end
    return true
end

function fourSquare(low,high,unique,prnt)
    count = 0
    if prnt then
        print("a", "b", "c", "d", "e", "f", "g")
    end
    for a=low,high do
        for b=low,high do
            if valid(unique, a, {b}) then
                fp = a + b
                for c=low,high do
                    if valid(unique, c, {a, b}) then
                        for d=low,high do
                            if valid(unique, d, {a, b, c}) and fp == b + c + d then
                                for e=low,high do
                                    if valid(unique, e, {a, b, c, d}) then
                                        for f=low,high do
                                            if valid(unique, f, {a, b, c, d, e}) and fp == d + e + f then
                                                for g=low,high do
                                                    if valid(unique, g, {a, b, c, d, e, f}) and fp == f + g then
                                                        count = count + 1
                                                        if prnt then
                                                            print(a, b, c, d, e, f, g)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if unique then
        print(string.format("There are %d unique solutions in [%d, %d]", count, low, high))
    else
        print(string.format("There are %d non-unique solutions in [%d, %d]", count, low, high))
    end
end

fourSquare(1,7,true,true)
fourSquare(3,9,true,true)
fourSquare(0,9,false,false)
