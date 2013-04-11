def step(state, rule) {
    var result := state(0, 1) # fixed left cell
    for i in 1..(state.size() - 2) {
        # Rule function receives the substring which is the neighborhood
        result += E.toString(rule(state(i-1, i+2)))
    }
    result += state(state.size() - 1) # fixed right cell
    return result
}

def play(var state, rule, count, out) {
    out.print(`0 | $state$\n`)
    for i in 1..count {
        state := step(state, rosettaRule)
        out.print(`$i | $state$\n`)
    }
    return state
}
