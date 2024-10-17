include std/sequence.e

constant line = "--------+--------------------\n"
constant digits = "123456789"
sequence list = {}

function get_digits(integer n)
    integer j
    sequence d = digits, ret = ""
    for i=1 to n do
        j = rand(length(digits)-i)
        ret &= d[i+j]
        if j then
            d[i+j] = d[i]
            d[i] = ret[i]
        end if
    end for
    return ret
end function

function MASK(integer x)
    return power(2,x-digits[1])
end function

function score(sequence pattern, sequence guess)
    integer bits = 0, bull = 0, cow = 0
    for i = 1 to length(guess) do
        if guess[i] != pattern[i] then
            bits += MASK(pattern[i])
        else
            bull += 1
        end if
    end for

    for i = 1 to length(guess) do
        cow += and_bits(bits,MASK(guess[i])) != 0
    end for

    return {bull, cow}
end function

procedure pick(integer n, integer got, integer marker, sequence buf)
    integer bits = 1
    if got >= n then
        list = append(list,buf)
    else
        for i = 0 to length(digits)-1 do
            if not and_bits(marker,bits) then
                buf[got+1] = i+digits[1]
                pick(n, got+1, or_bits(marker,bits), buf)
            end if
            bits *= 2
        end for
    end if
end procedure

function tester(sequence item, sequence data)
    return equal(score(item,data[1]),data[2])
end function

constant tester_id = routine_id("tester")

procedure game(sequence tgt)
    integer p, n = length(tgt)
    sequence buf = repeat(0,n), bc
    list = {}
    pick(n,0,0,buf)
    p = 1
    bc = {0,0}
    while bc[1]<n do
        buf = list[rand($)]
        bc = score(tgt,buf)
        printf(1,"Guess %2d| %s    (from: %d)\nScore   | %d bull, %d cow\n%s",
                    {p, buf, length(list)} & bc & {line})

        list = filter(list, tester_id, {buf, bc})
        p+=1
    end while
end procedure

constant n = 4
sequence secret = get_digits(n)
printf(1,"%sSecret  | %s\n%s", {line, secret, line})
game(secret)
