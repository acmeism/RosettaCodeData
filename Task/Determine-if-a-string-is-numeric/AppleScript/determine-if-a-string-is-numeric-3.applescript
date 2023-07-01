on isNumString(s)
    if (s's class is not text) then return false
    try
        s as number
        return true
    on error
        return false
    end try
end isNumString
