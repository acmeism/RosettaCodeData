function promptYN(q)
    local ans = '?'
    repeat
        io.write(q..'? ')
        ans = string.upper(io.read())
    until ans == 'Y' or ans == 'N'
    return ans == 'Y'
end

function getCharAt(s,i)
    return string.sub(s,i,i)
end

conditions = {
    {"Printer prints", "NNNNYYYY"},
    {"A red light is flashing", "YYNNYYNN"},
    {"Printer is recognized by computer", "NYNYNYNY"},
}

actions = {
    {"Check the power cable", "NNYNNNNN"},
    {"Check the printer-computer cable", "YNYNNNNN"},
    {"Ensure printer software is installed", "YNYNYNYN"},
    {"Check/replace ink", "YYNNNYNN"},
    {"Check for paper jam", "NYNYNNNN"},
}

nc = #conditions
nr = string.len(conditions[1][2])
answers = {}

print('Please answer the following questions with a y or n:')
for i,v in pairs(conditions) do
    answers[i] = promptYN(v[1])
end

print('Recommended action(s)')
for r=1,nr do
    local skip = false
    for c=1,nc do
        local yn = answers[c] and 'Y' or 'N'
        if getCharAt(conditions[c][2], r) ~= yn then
            skip = true
            break
        end
    end
    if not skip then
        if r == nr then
            print("  None (no problem detected)")
        else
            for i,a in pairs(actions) do
                if getCharAt(a[2], r) == 'Y' then
                    print("  ", a[1])
                end
            end
        end
    end
end
