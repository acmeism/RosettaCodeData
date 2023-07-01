function tokenize(rpn)
    local out = {}
    local cnt = 0
    for word in rpn:gmatch("%S+") do
        table.insert(out, word)
        cnt = cnt + 1
    end
    return {tokens = out, pos = 1, size = cnt}
end

function advance(lex)
    if lex.pos <= lex.size then
        lex.pos = lex.pos + 1
        return true
    else
        return false
    end
end

function current(lex)
    return lex.tokens[lex.pos]
end

function isOperator(sym)
    return sym == '+' or sym == '-'
        or sym == '*' or sym == '/'
        or sym == '^'
end

function buildTree(lex)
    local stack = {}

    while lex.pos <= lex.size do
        local sym = current(lex)
        advance(lex)

        if isOperator(sym) then
            local b = table.remove(stack)
            local a = table.remove(stack)

            local t = {op=sym, left=a, right=b}
            table.insert(stack, t)
        else
            table.insert(stack, sym)
        end
    end

    return table.remove(stack)
end

function infix(tree)
    if type(tree) == "table" then
        local a = {}
        local b = {}

        if type(tree.left) == "table" then
            a = '(' .. infix(tree.left) .. ')'
        else
            a = tree.left
        end

        if type(tree.right) == "table" then
            b = '(' .. infix(tree.right) .. ')'
        else
            b = tree.right
        end

        return a .. ' ' .. tree.op .. ' ' .. b
    else
        return tree
    end
end

function convert(str)
    local lex = tokenize(str)
    local tree = buildTree(lex)
    print(infix(tree))
end

function main()
    convert("3 4 2 * 1 5 - 2 3 ^ ^ / +")
    convert("1 2 + 3 4 + ^ 5 6 + ^")
end

main()
