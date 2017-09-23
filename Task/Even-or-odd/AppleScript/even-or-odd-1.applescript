set nList to {3, 2, 1, 0, -1, -2, -3}
repeat with n in nList
    if (n / 2) = n / 2 as integer then
        log "Value " & n & " is even."
    else
        log "Value " & n & " is odd."
    end if
end repeat
