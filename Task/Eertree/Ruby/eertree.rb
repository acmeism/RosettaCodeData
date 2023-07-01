class Node
    def initialize(length, edges = {}, suffix = 0)
        @length = length
        @edges = edges
        @suffix = suffix
    end

    attr_reader :length
    attr_reader :edges
    attr_accessor :suffix
end

EVEN_ROOT = 0
ODD_ROOT = 1

def eertree(s)
    tree = [
        Node.new(0, {}, ODD_ROOT),
        Node.new(-1, {}, ODD_ROOT)
    ]
    suffix = ODD_ROOT
    s.each_char.with_index { |c, i|
        n = suffix
        k = 0
        loop do
            k = tree[n].length
            b = i - k - 1
            if b >= 0 and s[b] == c then
                break
            end
            n = tree[n].suffix
        end
        if tree[n].edges.key?(c) then
                suffix = tree[n].edges[c]
            next
        end
        suffix = tree.length
        tree << Node.new(k + 2)
        tree[n].edges[c] = suffix
        if tree[suffix].length == 1 then
            tree[suffix].suffix = 0
            next
        end
        loop do
            n = tree[n].suffix
            b = i - tree[n].length - 1
            if b >= 0 and s[b] == c then
                break
            end
        end
        tree[suffix].suffix = tree[n].edges[c]
    }
    return tree
end

def subPalindromes(tree)
    s = []

    children = lambda { |n,p,f|
        for c,v in tree[n].edges
            m = tree[n].edges[c]
            p = c + p + c
            s << p
            f.call(m, p, f)
        end
    }

    children.call(0, '', children)

    for c,n in tree[1].edges
        s << c
        children.call(n, c, children)
    end

    return s
end

tree = eertree("eertree")
print subPalindromes(tree), "\n"
