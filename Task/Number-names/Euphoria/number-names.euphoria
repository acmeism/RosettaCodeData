function abs(atom i)
    if i < 0 then
        return -i
    else
        return i
    end if
end function

constant small = {"one", "two", "three", "four", "five", "six", "seven", "eight",
    "nine", "ten","eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen",
    "seventeen", "eighteen", "nineteen"}

constant tens = {"twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty",
    "ninety"}

constant big = {"thousand", "million", "billion"}

function int2text(atom number)
    atom num
    integer unit, tmpLng1
    sequence outP
    outP = ""
    num = 0
    unit = 1
    tmpLng1 = 0

    if number = 0 then
        return "zero"
    end if

    num = abs(number)
    while 1 do
        tmpLng1 = remainder(num,100)
        if tmpLng1 > 0 and tmpLng1 < 20 then
            outP = small[tmpLng1] & ' ' & outP
        elsif tmpLng1 >= 20 then
            if remainder(tmpLng1,10) = 0 then
                outP = tens[floor(tmpLng1/10)-1] & ' ' & outP
            else
                outP = tens[floor(tmpLng1/10)-1] & '-' & small[remainder(tmpLng1, 10)] & ' ' & outP
            end if
        end if

        tmpLng1 = floor(remainder(num, 1000) / 100)
        if tmpLng1 then
            outP = small[tmpLng1] & " hundred " & outP
        end if

        num = floor(num/1000)
        if num < 1 then
            exit
        end if

        tmpLng1 = remainder(num,1000)
        if tmpLng1 then
            outP = big[unit] & ' ' & outP
        end if

        unit = unit + 1
    end while

    if number < 0 then
        outP = "negative " & outP
    end if

    return outP[1..$-1]
end function

puts(1,int2text(900000001) & "\n")
puts(1,int2text(1234567890) & "\n")
puts(1,int2text(-987654321) & "\n")
puts(1,int2text(0) & "\n")
