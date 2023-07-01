function duration (secs)
    local units, dur = {"wk", "d", "hr", "min"}, ""
    for i, v in ipairs({604800, 86400, 3600, 60}) do
        if secs >= v then
            dur = dur .. math.floor(secs / v) .. " " .. units[i] .. ", "
            secs = secs % v
        end
    end
    if secs == 0 then
        return dur:sub(1, -3)
    else
        return dur .. secs .. " sec"
    end
end

print(duration(7259))
print(duration(86400))
print(duration(6000000))
