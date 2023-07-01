function longer(s1, s2)
    if s1:sub(#s2):find('^$') then
       return false
    else
       return true
    end
end
