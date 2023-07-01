i = 0
count = 0
while count < 19
    if is_disarium(i)
        see "" + i + " "
        count++
    ok
    i++
end
see nl

func pow (base, exp)
    result = 1
    for i = 0 to exp - 1
        result *= base
    next
    return result

func is_disarium (num)
    n = "" + num
    sum = 0
    for i = 1 to len(n)
        sum += pow (n[i] % 10, i)
    next
    return sum = num
