function vlq_encode(integer n)
    sequence s
    s = {}
    while n > 0 do
        s = prepend(s, #80 * (length(s) > 0) + and_bits(n, #7F))
        n = floor(n / #80)
    end while
    if length(s) = 0 then
        s = {0}
    end if
    return s
end function

function vlq_decode(sequence s)
    integer n
    n = 0
    for i = 1 to length(s) do
        n *= #80
        n += and_bits(s[i], #7F)
        if not and_bits(s[i], #80) then
            exit
        end if
    end for
    return n
end function

function svlg(sequence s)
    sequence out
    out = ""
    for i = 1 to length(s) do
        out &= sprintf("#%02x:", {s[i]})
    end for
    return out[1..$-1]
end function

constant testNumbers = { #200000, #1FFFFF, 1, 127, 128 }
sequence s
for i = 1 to length(testNumbers) do
    s = vlq_encode(testNumbers[i])
    printf(1, "#%02x -> %s -> #%02x\n", {testNumbers[i], svlg(s), vlq_decode(s)})
end for
