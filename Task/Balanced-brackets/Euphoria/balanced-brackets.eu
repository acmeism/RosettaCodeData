function check_brackets(sequence s)
    integer level
    level = 0
    for i = 1 to length(s) do
        if s[i] = '[' then
            level += 1
        elsif s[i] = ']' then
            level -= 1
            if level < 0 then
                return 0
            end if
        end if
    end for
    return level = 0
end function

function generate_brackets(integer n)
    integer opened,closed,r
    sequence s
    opened = n
    closed = n
    s = ""
    for i = 1 to n*2 do
        r = rand(opened+closed)
        if r<=opened then
            s &= '['
            opened -= 1
        else
            s &= ']'
            closed -= 1
        end if
    end for
    return s
end function

sequence s
for i = 1 to 10 do
    s = generate_brackets(3)
    puts(1,s)
    if check_brackets(s) then
        puts(1," OK\n")
    else
        puts(1," NOT OK\n")
    end if
end for
