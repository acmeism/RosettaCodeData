--[[
Returns a table of substrings by splitting the given string on
occurrences of the given character delimiters, which may be specified
as a single- or multi-character string or a table of such strings.
If chars is omitted, it defaults to the set of all space characters,
and keep is taken to be false. The limit and keep arguments are
optional: they are a maximum size for the result and a flag
determining whether empty fields should be kept in the result.
]]
function split (str, chars, limit, keep)
    local limit, splitTable, entry, pos, match = limit or 0, {}, "", 1
    if keep == nil then keep = true end
    if not chars then
        for e in string.gmatch(str, "%S+") do
                table.insert(splitTable, e)
        end
        return splitTable
    end
    while pos <= str:len() do
        match = nil
        if type(chars) == "table" then
            for _, delim in pairs(chars) do
                if str:sub(pos, pos + delim:len() - 1) == delim then
                    match = string.len(delim) - 1
                    break
                end
            end
        elseif str:sub(pos, pos + chars:len() - 1) == chars then
            match = string.len(chars) - 1
        end
        if match then
            if not (keep == false and entry == "") then
                table.insert(splitTable, entry)
                if #splitTable == limit then return splitTable end
                entry = ""
            end
        else
            entry = entry .. str:sub(pos, pos)
        end
        pos = pos + 1 + (match or 0)
    end
    if entry ~= "" then table.insert(splitTable, entry) end
    return splitTable
end

local multisplit = split("a!===b=!=c", {"==", "!=", "="})

-- Returned result is a table (key/value pairs) - display all entries
print("Key\tValue")
print("---\t-----")
for k, v in pairs(multisplit) do
    print(k, v)
end
