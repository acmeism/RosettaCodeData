using Lazy

"""
    Input a tree for display as a fringed structure.
"""
function fringe(tree)
    fringey(node::Pair) = [fringey(i) for i in node]
    fringey(leaf::Int) = leaf
    fringey(tree)
end


"""
    equalsfringe() uses a reduction to a lazy 1D list via
    getleaflist() for its "equality" of fringes
"""
getleaflist(tree::Int) = [tree]
getleaflist(tree::Pair) = vcat(getleaflist(seq(tree[1])), getleaflist(seq(tree[2])))
getleaflist(tree::Lazy.LazyList) = vcat(getleaflist(tree[1]), getleaflist(tree[2]))
getleaflist(tree::Void) = []
equalsfringe(t1, t2) = (getleaflist(t1) == getleaflist(t2))


a = 1 => 2 => 3 => 4 => 5 => 6 => 7 => 8
b = 1 => (( 2 => 3 ) => (4 => (5 => ((6 => 7) => 8))))
c = (((1 => 2) => 3) => 4) => 5 => 6 => 7 => 8

x = 1 => 2 => 3 => 4 => 5 => 6 => 7 => 8 => 9
y = 0 => 2 => 3 => 4 => 5 => 6 => 7 => 8
z = 1 => 2 => (4 => 3) => 5 => 6 => 7 => 8

prettyprint(s) = println(replace("$s", r"\{Any,1\}|Any|Array\{T,1\}\swhere\sT|Array|", ""))
prettyprint(fringe(a))
prettyprint(fringe(b))
prettyprint(fringe(c))
prettyprint(fringe(x))
prettyprint(fringe(y))
prettyprint(fringe(z))

prettyprint(getleaflist(a))
prettyprint(getleaflist(b))
prettyprint(getleaflist(c))

println(equalsfringe(a, a))
println(equalsfringe(a, b))
println(equalsfringe(a, c))
println(equalsfringe(b, c))
println(equalsfringe(a, x) == false)
println(equalsfringe(a, y) == false)
println(equalsfringe(a, z) == false)
