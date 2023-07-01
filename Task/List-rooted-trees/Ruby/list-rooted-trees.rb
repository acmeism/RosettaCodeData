TREE_LIST = []
OFFSET = []

for i in 0..31
    if i == 1 then
        OFFSET << 1
    else
        OFFSET << 0
    end
end

def append(t)
    TREE_LIST << (1 | (t << 1))
end

def show(t, l)
    while l > 0
        l = l - 1
        if t % 2 == 1 then
            print '('
        else
            print ')'
        end
        t = t >> 1
    end
end

def listTrees(n)
    for i in OFFSET[n] .. OFFSET[n + 1] - 1
        show(TREE_LIST[i], n * 2)
        print "\n"
    end
end

def assemble(n, t, sl, pos, rem)
    if rem == 0 then
        append(t)
        return
    end

    if sl > rem then
        sl = rem
        pos = OFFSET[sl]
    elsif pos >= OFFSET[sl + 1] then
        sl = sl - 1
        if sl == 0 then
            return
        end
        pos = OFFSET[sl]
    end

    assemble(n, t << (2 * sl) | TREE_LIST[pos], sl, pos, rem - sl)
    assemble(n, t, sl, pos + 1, rem)
end

def makeTrees(n)
    if OFFSET[n + 1] != 0 then
        return
    end
    if n > 0 then
        makeTrees(n - 1)
    end
    assemble(n, 0, n - 1, OFFSET[n - 1], n - 1)
    OFFSET[n + 1] = TREE_LIST.length()
end

def test(n)
    if n < 1 || n > 12 then
        raise ArgumentError.new("Argument must be between 1 and 12")
    end

    append(0)

    makeTrees(n)
    print "Number of %d-trees: %d\n" % [n, OFFSET[n + 1] - OFFSET[n]]
    listTrees(n)
end

test(5)
