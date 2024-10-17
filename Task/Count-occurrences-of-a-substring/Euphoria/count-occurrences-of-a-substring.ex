function countSubstring(sequence s, sequence sub)
    integer from,count
    count = 0
    from = 1
    while 1 do
        from = match_from(sub,s,from)
        if not from then
            exit
        end if
        from += length(sub)
        count += 1
    end while
    return count
end function

? countSubstring("the three truths","th")
? countSubstring("ababababab","abab")
