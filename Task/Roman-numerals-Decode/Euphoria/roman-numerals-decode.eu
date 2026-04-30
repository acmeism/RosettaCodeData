constant symbols = "MDCLXVI", weights = {1000,500,100,50,10,5,1}
function romanDec(sequence roman)
    integer n, lastval, arabic
    lastval = 0
    arabic = 0
    for i = length(roman) to 1 by -1 do
        n = find(roman[i],symbols)
        if n then
            n = weights[n]
        end if
        if n < lastval then
            arabic -= n
        else
            arabic += n
        end if
        lastval = n
    end for
    return arabic
end function

? romanDec("MCMXCIX")
? romanDec("MDCLXVI")
? romanDec("XXV")
? romanDec("CMLIV")
? romanDec("MMXI")
