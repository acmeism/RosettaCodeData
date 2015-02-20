function splittokens(s)
    local res = {}
    for w in s:gmatch("%S+") do
        res[#res+1] = w
    end
    return res
end

function textwrap(text, linewidth)
    if not linewidth then
        linewidth = 75
    end

    local spaceleft = linewidth
    local res = {}
    local line = {}

    for _, word in ipairs(splittokens(text)) do
        if #word + 1 > spaceleft then
            table.insert(res, table.concat(line, ' '))
            line = {word}
            spaceleft = linewidth - #word
        else
            table.insert(line, word)
            spaceleft = spaceleft - (#word + 1)
        end
    end

    table.insert(res, table.concat(line, ' '))
    return table.concat(res, '\n')
end

local example1 = [[
Even today, with proportional fonts and complex layouts,
there are still cases where you need to wrap text at a
specified column. The basic task is to wrap a paragraph
of text in a simple way in your language. If there is a
way to do this that is built-in, trivial, or provided in
a standard library, show that. Otherwise implement the
minimum length greedy algorithm from Wikipedia.
]]

print(textwrap(example1))
print()
print(textwrap(example1, 60))
