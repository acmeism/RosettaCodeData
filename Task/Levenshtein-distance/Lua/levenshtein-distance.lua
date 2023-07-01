function leven(s,t)
    if s == '' then return t:len() end
    if t == '' then return s:len() end

    local s1 = s:sub(2, -1)
    local t1 = t:sub(2, -1)

    if s:sub(0, 1) == t:sub(0, 1) then
        return leven(s1, t1)
    end

    return 1 + math.min(
        leven(s1, t1),
        leven(s,  t1),
        leven(s1, t )
      )
end

print(leven("kitten", "sitting"))
print(leven("rosettacode", "raisethysword"))
