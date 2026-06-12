function make_pal( n as ulongint ) as ulongint
    'turn a number into a palindrom with twice as many digits
    dim as string ns, ret
    ns = str(n) : ret = ns
    for i as uinteger = len(ns) to 1 step -1
       ret += mid(ns, i, 1)
    next i
    return val(ret)
end function

function has_dig( n as ulongint, d as uinteger ) as boolean
    'does the number n have d decimal digits?
    if 10^(d-1)<=n and n<10^d then return true else return false
end function

dim as integer np

for d as uinteger = 2 to 7
    for n as ulongint = 10^d - 1 to 10^(d-1) step -1 'count down from 999...
                                                     'since the first good number we encounter
                                                     'must be the highest
        np = make_pal( n )                           'produce a 2d-digit palindrome from it
        for f as ulongint = 10^d - 1 to 10^(d-1) step -1   'look for highest d-digit factor
            if np mod f = 0 then
                if has_dig( np/f, d ) then           'if np/f also has d digits we are done :)
                    print f;" *";np/f;" =";np
                    goto nextd
                end if
            end if
        next f
    next n
    nextd:                                           'yes, I used a goto. sue me.
next d
