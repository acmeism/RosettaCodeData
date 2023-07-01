function get_digit( num as uinteger, ps as uinteger ) as uinteger
    return (num mod 10^(ps+1))\10^ps
end function

function is_malformed( num as uinteger ) as boolean
    if num > 9876 then return true
    dim as uinteger i, j
    for i = 0 to 2
        for j = i+1 to 3
            if get_digit( num, j ) = get_digit( num, i ) then return true
        next j
    next i
    return false
end function

function make_number() as uinteger
    dim as uinteger num = 0
    while is_malformed(num)
        num = int(rnd*9877)
    wend
    return num
end function

randomize timer

dim as uinteger count=0, num=make_number(), guess=0
dim as uinteger cows, bulls, i, j

while guess <> num
    count += 1
    do
        print "Guess a number. "
        input guess
    loop while is_malformed(guess)

    cows = 0
    bulls = 0

    for i = 0 to 3
        for j = 0 to 3
            if get_digit( num, i ) = get_digit( guess, j ) then
                if i= j then bulls += 1
                if i<>j then cows  += 1
            end if
        next j
    next i
    print using "You scored # bulls and # cows."; bulls; cows
wend

print using "Correct. That took you ### guesses."; count
