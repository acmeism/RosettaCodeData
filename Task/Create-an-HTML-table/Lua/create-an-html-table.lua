function htmlTable (data)
    local html = "<table>\n<tr>\n<th></th>\n"
    for _, heading in pairs(data[1]) do
        html = html .. "<th>" .. heading .. "</th>" .. "\n"
    end
    html = html .. "</tr>\n"
    for row = 2, #data do
        html = html .. "<tr>\n<th>" .. row - 1 .. "</th>\n"
        for _, field in pairs(data[row]) do
            html = html .. "<td>" .. field .. "</td>\n"
        end
        html = html .. "</tr>\n"
    end
    return html .. "</table>"
end

local tableData = {
    {"X", "Y", "Z"},
    {"1", "2", "3"},
    {"4", "5", "6"},
    {"7", "8", "9"}
}

print(htmlTable(tableData))
