-- Machine definitions
local incrementer = {
    name = "Simple incrementer",
    initState = "q0",
    endState = "qf",
    blank = "B",
    rules = {
        {"q0", "1", "1", "right", "q0"},
        {"q0", "B", "1", "stay", "qf"}
    }
}

local threeStateBB = {
    name = "Three-state busy beaver",
    initState = "a",
    endState = "halt",
    blank = "0",
    rules = {
        {"a", "0", "1", "right", "b"},
        {"a", "1", "1", "left", "c"},
        {"b", "0", "1", "left", "a"},
        {"b", "1", "1", "right", "b"},
        {"c", "0", "1", "left", "b"},
        {"c", "1", "1", "stay", "halt"}
    }
}

local fiveStateBB = {
    name = "Five-state busy beaver",
    initState = "A",
    endState = "H",
    blank = "0",
    rules = {
        {"A", "0", "1", "right", "B"},
        {"A", "1", "1", "left", "C"},
        {"B", "0", "1", "right", "C"},
        {"B", "1", "1", "right", "B"},
        {"C", "0", "1", "right", "D"},
        {"C", "1", "0", "left", "E"},
        {"D", "0", "1", "left", "A"},
        {"D", "1", "1", "left", "D"},
        {"E", "0", "1", "stay", "H"},
        {"E", "1", "0", "left", "A"}
    }
}

-- Display a representation of the tape and machine state on the screen
function show (state, headPos, tape)
    local leftEdge = 1
    while tape[leftEdge - 1] do leftEdge = leftEdge - 1 end
    io.write(" " .. state .. "\t| ")
    for pos = leftEdge, #tape do
        if pos == headPos then io.write("[" .. tape[pos] .. "] ") else io.write(" " .. tape[pos] .. "  ") end
    end
    print()
end

-- Simulate a turing machine
function UTM (machine, tape, countOnly)
    local state, headPos, counter = machine.initState, 1, 0
    print("\n\n" .. machine.name)
    print(string.rep("=", #machine.name) .. "\n")
    if not countOnly then print(" State", "| Tape [head]\n---------------------") end
    repeat
        if not tape[headPos] then tape[headPos] = machine.blank end
        if not countOnly then show(state, headPos, tape) end
        for _, rule in ipairs(machine.rules) do
            if rule[1] == state and rule[2] == tape[headPos] then
                tape[headPos] = rule[3]
                if rule[4] == "left" then headPos = headPos - 1 end
                if rule[4] == "right" then headPos = headPos + 1 end
                state = rule[5]
                break
            end
        end
        counter = counter + 1
    until state == machine.endState
    if countOnly then print("Steps taken: " .. counter) else show(state, headPos, tape) end
end

-- Main procedure
UTM(incrementer, {"1", "1", "1"})
UTM(threeStateBB, {})
UTM(fiveStateBB, {}, "countOnly")
