constant arabic = {1000, 900, 500, 400, 100, 90, 50,  40,  10,  9,  5,   4,  1 }
constant roman  = {"M", "CM", "D","CD", "C","XC","L","XL","X","IX","V","IV","I"}

function toRoman(integer val)
    sequence result
    result = ""
    for i = 1 to 13 do
        while val >= arabic[i] do
            result &= roman[i]
            val -= arabic[i]
        end while
    end for
    return result
end function

printf(1,"%d = %s\n",{2009,toRoman(2009)})
printf(1,"%d = %s\n",{1666,toRoman(1666)})
printf(1,"%d = %s\n",{3888,toRoman(3888)})
