include std/console.e
include std/text.e

sequence removables = " \t\n\r\x05\u0234\" "
sequence extraSeq = "  \x05\r \" A  B  C  \n \t\t  \u0234 \r\r \x05   "

extraSeq = trim(extraSeq,removables) --the work is done by the trim function

--only output programming next :
printf(1, "String Trimmed is now: %s \r\n", {extraSeq} ) --print the resulting string to screen

for i = 1 to length(extraSeq) do --loop over each character in the sequence.
    printf(1, "String element %d", i) --to look at more detail,
    printf(1, " : %d\r\n", extraSeq[i])--print integer values(ascii) of the string.
end for

any_key()
