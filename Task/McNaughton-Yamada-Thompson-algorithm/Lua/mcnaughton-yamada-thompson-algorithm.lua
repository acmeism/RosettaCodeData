-- State class
local State = {}
State.__index = State

function State:new(label)
    local obj = {
        label = label or "\0",
        edge1 = nil,
        edge2 = nil
    }
    setmetatable(obj, self)
    return obj
end

-- NFA class
local NFA = {}
NFA.__index = NFA

function NFA:new(initial, accept)
    local obj = {
        initial = initial,
        accept = accept
    }
    setmetatable(obj, self)
    return obj
end

-- Helper function to check if a state array contains a specific state
local function contains_state(states, target)
    for _, state in ipairs(states) do
        if state == target then  -- Reference equality
            return true
        end
    end
    return false
end

-- Compute the epsilon closure of the given state
local function followes(state)
    local states = {}
    local stack = {state}

    while #stack > 0 do
        local current = table.remove(stack)
        if not contains_state(states, current) then
            table.insert(states, current)
            if current.label == "\0" then  -- Epsilon transition
                if current.edge1 then
                    table.insert(stack, current.edge1)
                end
                if current.edge2 then
                    table.insert(stack, current.edge2)
                end
            end
        end
    end

    return states
end

-- Convert the given infix regex to postfix regex using the Shunting Yard algorithm
local function shunt(infix)
    local specials = {
        ['*'] = 60,
        ['+'] = 55,
        ['?'] = 50,
        ['.'] = 40,
        ['|'] = 20
    }

    local stack = {}
    local postfix = ""

    for i = 1, #infix do
        local ch = infix:sub(i, i)

        if ch == '(' then
            table.insert(stack, ch)
        elseif ch == ')' then
            while #stack > 0 and stack[#stack] ~= '(' do
                postfix = postfix .. table.remove(stack)
            end
            if #stack > 0 then
                table.remove(stack)  -- Remove '('
            end
        elseif specials[ch] then
            while #stack > 0 and specials[stack[#stack]] and
                  specials[ch] <= specials[stack[#stack]] do
                postfix = postfix .. table.remove(stack)
            end
            table.insert(stack, ch)
        else
            postfix = postfix .. ch
        end
    end

    while #stack > 0 do
        postfix = postfix .. table.remove(stack)
    end

    return postfix
end

-- Compile the given postfix regex into an NFA
local function compile_regex(postfix)
    local nfa_stack = {}

    for i = 1, #postfix do
        local ch = postfix:sub(i, i)

        if ch == '*' then
            local nfa1 = table.remove(nfa_stack)
            local initial = State:new()
            local accept = State:new()
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            table.insert(nfa_stack, NFA:new(initial, accept))
        elseif ch == '.' then
            local nfa2 = table.remove(nfa_stack)
            local nfa1 = table.remove(nfa_stack)
            nfa1.accept.edge1 = nfa2.initial
            table.insert(nfa_stack, NFA:new(nfa1.initial, nfa2.accept))
        elseif ch == '|' then
            local nfa2 = table.remove(nfa_stack)
            local nfa1 = table.remove(nfa_stack)
            local initial = State:new()
            local accept = State:new()
            initial.edge1 = nfa1.initial
            initial.edge2 = nfa2.initial
            nfa1.accept.edge1 = accept
            nfa2.accept.edge1 = accept
            table.insert(nfa_stack, NFA:new(initial, accept))
        elseif ch == '+' then
            local nfa1 = table.remove(nfa_stack)
            local initial = State:new()
            local accept = State:new()
            initial.edge1 = nfa1.initial
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            table.insert(nfa_stack, NFA:new(initial, accept))
        elseif ch == '?' then
            local nfa1 = table.remove(nfa_stack)
            local initial = State:new()
            local accept = State:new()
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = accept
            table.insert(nfa_stack, NFA:new(initial, accept))
        else  -- Literal character
            local initial = State:new(ch)
            local accept = State:new()
            initial.edge1 = accept
            table.insert(nfa_stack, NFA:new(initial, accept))
        end
    end

    return nfa_stack[#nfa_stack]
end

-- Match the given string against the given infix regex
local function match_regex(text, infix)
    local postfix = shunt(infix)
    -- Uncomment the next line to see the postfix expression
    -- print("Postfix: " .. postfix)

    local nfa = compile_regex(postfix)

    local current = followes(nfa.initial)
    local next_states = {}

    for i = 1, #text do
        local ch = text:sub(i, i)
        for _, state in ipairs(current) do
            if state.label == ch then
                local follow = followes(state.edge1)
                for _, s in ipairs(follow) do
                    table.insert(next_states, s)
                end
            end
        end
        current = next_states
        next_states = {}
    end

    return contains_state(current, nfa.accept)
end

-- Main function
local function main()
    local infixes = {"a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"}
    local strings = {"", "abc", "abbc", "abcc", "abad", "abbbc"}

    for _, infix in ipairs(infixes) do
        for _, string in ipairs(strings) do
            local result = match_regex(string, infix)
            print((result and "True " or "False ") .. infix .. " " .. string)
        end
        print()
    end
end

-- Run the main function
main()
