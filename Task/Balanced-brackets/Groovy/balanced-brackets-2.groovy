boolean balancedBrackets(String brackets, int depth=0) {
    if (brackets == null || brackets.empty) return depth == 0
    switch (brackets[0]) {
        case '[':
            return brackets.size() > 1  &&  balancedBrackets(brackets[1..-1], depth + 1)
        case ']':
            return depth > 0  &&  (brackets.size() == 1  ||  balancedBrackets(brackets[1..-1], depth - 1))
        default:
            return brackets.size() == 1  ?  depth == 0  :  balancedBrackets(brackets[1..-1], depth)
    }
}
