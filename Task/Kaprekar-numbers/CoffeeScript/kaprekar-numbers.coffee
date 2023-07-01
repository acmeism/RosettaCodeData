splitAt = (str, idx) ->
    ans = [ str.substring(0, idx), str.substring(idx) ]
    if ans[0] == ""
        ans[0] = "0"
    ans

getKaprekarParts = (longValue, sqrStr, base) ->
    for j in [ 0 .. sqrStr.length / 2 ]
        parts = splitAt(sqrStr, j)
        nums = (parseInt(n, base) for n in parts)

        # if the right part is all zeroes, then it will be forever, so break
        if nums[1] == 0
            return null
        if nums[0] + nums[1] == longValue
            return parts
    null

base = 10
count = 0
max = 1000000
for i in [1..max]
    i2 = i * i
    s = i2.toString(base)
    p = getKaprekarParts i, s, base
    if p
        console.log i, i.toString(base), s, p.join '+'
        count++
console.log "#{count} Kaprekar numbers < #{max} (base 10) in base #{base}"
