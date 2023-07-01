pragma.enable("accumulator") # non-finalized syntax feature

def max([first] + rest) {
    return accum first for x in rest { _.max(x) }
}
