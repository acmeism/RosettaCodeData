def fact = { n -> [1,(1..<(n+1)).inject(1) { prod, i -> prod * i }].max() }
def missingPerms
missingPerms = {List elts, List perms ->
    perms.empty ? elts.permutations() : elts.collect { e ->
        def ePerms = perms.findAll { e == it[0] }.collect { it[1..-1] }
        ePerms.size() == fact(elts.size() - 1) ? [] \
            : missingPerms(elts - e, ePerms).collect { [e] + it }
    }.sum()
}
