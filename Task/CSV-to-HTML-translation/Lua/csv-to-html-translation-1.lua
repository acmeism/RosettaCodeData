FS = ","            -- field separator

csv = [[
Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!
]]

csv = csv:gsub( "<", "&lt;" )
csv = csv:gsub( ">", "&gr;" )

html = { "<table>" }
for line in string.gmatch( csv, "(.-\n)" ) do
    str = "<tr>"
    for field in string.gmatch( line, "(.-)["..FS.."?\n?]" ) do
        str = str .. "<td>" .. field .. "</td>"
    end
    str = str .. "</tr>"
    html[#html+1] = str;
end
html[#html+1] = "</table>"

for _, line in pairs(html) do
    print(line)
end
