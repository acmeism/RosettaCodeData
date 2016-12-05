#!/usr/bin/awk -f
BEGIN {
    edge = 1
    ruleNum = 104 # 01101000
    maxGen = 9
    mark = "@"
    space = "."
    initialState = ".@@@.@@.@.@.@.@..@.."
    width = length(initialState)
    delete rules
    delete state

    initRules(ruleNum)
    initState(initialState, mark)
    for (g = 0; g < maxGen; g++) {
        showState(g, mark, space)
        nextState()
    }
    showState(g, mark, space)
}

function nextState(    newState, i, n) {
    delete newState
    for (i = 1; i < width - 1; i++) {
        n = getRuleNum(i)
        newState[i] = rules[n]
    }
    for (i = 0; i < width; i++) { # copy, can't assign arrays
        state[i] = newState[i]
    }
}

# Convert a three cell neighborhood from binary to decimal
function getRuleNum(i,    rn, j, p) {
    rn = 0
    for (j = -1; j < 2; j++) {
        p = i + j
        rn = rn * 2 + (p < 0 || p > width ? edge : state[p])
    }
    return rn
}

function showState(gen, mark, space,    i) {
    printf("%3d: ", gen)
    for (i = 1; i <= width; i++) {
        printf(" %s", (state[i] ? mark : space))
    }
    print ""
}

# Make state transition lookup table from rule number.
function initRules(ruleNum,   i, r) {
    delete rules;
    r = ruleNum
    for (i = 0; i < 8; i++) {
        rules[i] = r % 2
        r = int(r / 2)
    }
}

function initState(init, mark,    i) {
    delete state
    srand()
    for (i = 0; i < width; i++) {
        state[i] = (substr(init, i, 1) == mark ? 1 : 0) # Given an initial string.
        # state[int(width/2)] = '@'  # middle cell
        # state[i] = int(rand() * 100) < 30 ? 1 : 0 # 30% of cells
    }
}
