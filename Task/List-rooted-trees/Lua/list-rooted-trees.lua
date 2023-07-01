tree_list = {}
offset = {}

function init()
    for i=1,32 do
        if i == 2 then
            table.insert(offset, 1)
        else
            table.insert(offset, 0)
        end
    end
end

function append(t)
    local v = 1 | (t << 1)
    table.insert(tree_list, v)
end

function show(t, l)
    while l > 0 do
        l = l - 1
        if (t % 2) == 1 then
            io.write('(')
        else
            io.write(')')
        end
        t = t >> 1
    end
end

function listTrees(n)
    local i = offset[n]
    while i < offset[n + 1] do
        show(tree_list[i + 1], n * 2)
        print()
        i = i + 1
    end
end

function assemble(m, t, sl, pos, rem)
    if rem == 0 then
        append(t)
        return
    end

    local pp = pos
    local ss = sl

    if sl > rem then
        ss = rem
        pp = offset[ss]
    elseif pp >= offset[ss + 1] then
        ss = ss - 1
        if ss == 0 then
            return
        end
        pp = offset[ss]
    end

    assemble(n, t << (2 * ss) | tree_list[pp + 1], ss, pp, rem - ss)
    assemble(n, t, ss, pp + 1, rem)
end

function makeTrees(n)
    if offset[n + 1] ~= 0 then
        return
    end
    if n > 0 then
        makeTrees(n - 1)
    end
    assemble(n, 0, n - 1, offset[n - 1], n - 1)
    offset[n + 1] = #tree_list
end

function test(n)
    append(0)

    makeTrees(n)
    print(string.format("Number of %d-trees: %d", n, offset[n+1] - offset[n]))
    listTrees(n)
end

init()
test(5)
