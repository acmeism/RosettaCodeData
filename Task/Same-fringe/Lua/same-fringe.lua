local type, insert, remove = type, table.insert, table.remove

None = {} -- a unique object for a truncated branch (i.e. empty subtree)
function isbranch(node) return type(node) == 'table' and #node == 2 end
function left(node) return node[1] end
function right(node) return node[2] end

function fringeiter(tree)
    local agenda = {tree}
    local function push(item) insert(agenda, item) end
    local function pop() return remove(agenda) end
    return function()
        while #agenda > 0 do
            node = pop()
            if isbranch(node) then
                push(right(node))
                push(left(node))
            elseif node == None then
                -- continue
            else
                return node
            end
        end
    end
end

function same_fringe(atree, btree)
    local anext = fringeiter(atree or None)
    local bnext = fringeiter(btree or None)
    local pos = 0
    repeat
        local aitem, bitem = anext(), bnext()
        pos = pos + 1
        if aitem ~= bitem then
            return false, string.format("at position %d, %s ~= %s", pos, aitem, bitem)
        end
    until not aitem
    return true
end

t1 = {1, {2, {3, {4, {5, None}}}}}
t2 = {{1,2}, {{3, 4}, 5}}
t3 = {{{1,2}, 3}, 4}

function compare_fringe(label, ta, tb)
    local equal, nonmatch = same_fringe(ta, tb)
    io.write(label .. ": ")
    if equal then
        print("same fringe")
    else
        print(nonmatch)
    end
end

compare_fringe("(t1, t2)", t1, t2)
compare_fringe("(t1, t3)", t1, t3)
