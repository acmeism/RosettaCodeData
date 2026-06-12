abstract type MYT end

struct NIL_MYT <: MYT end
const None = NIL_MYT()

mutable struct State <: MYT
    label::Char
    edge1::MYT
    edge2::MYT
    State(ch = '\0') = new(ch, None, None)
end

mutable struct NFA
    initial::State
    accept::State
    NFA(initial = None, accept = None) = new(initial, accept)
end

function shunt(infix)
    specials = Dict(
        '*' => 60,
        '+' => 55,
        '?' => 50,
        '.' => 40,
        '|' => 20,
    )
    postfix = Char[]
    stack = Char[]

    for c in infix
        if c == '('
            push!(stack, c)
        elseif c == ')'
            while !isempty(stack) && stack[end] != '('
                push!(postfix, pop!(stack))
            end
            if !isempty(stack)
                pop!(stack)  # Remove '('
            end
        elseif haskey(specials, c)
            while !isempty(stack) && haskey(specials, stack[end]) && specials[c] <= specials[stack[end]]
                push!(postfix, pop!(stack))
            end
            push!(stack, c)
        else
            push!(postfix, c)
        end
    end
    while !isempty(stack)
        push!(postfix, pop!(stack))
    end
    return postfix
end

function followes(state)
    states = Set{State}()
    stack = [state]

    while !isempty(stack)
        s = pop!(stack)
        if s ∉ states
            push!(states, s)
            if s.label == '\0'  # Epsilon transition
                if s.edge1 != None
                    push!(stack, s.edge1)
                end
                if s.edge2 != None
                    push!(stack, s.edge2)
                end
            end
        end
    end
    return states
end

function compileRegex(postfix)
    nfaStack = NFA[]
    for c in postfix
        if c == '*'
            nfa1 = pop!(nfaStack)
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            push!(nfaStack, NFA(initial, accept))
        elseif c == '.'
            nfa2 = pop!(nfaStack)
            nfa1 = pop!(nfaStack)
            nfa1.accept.edge1 = nfa2.initial
            push!(nfaStack, NFA(nfa1.initial, nfa2.accept))
        elseif c == '|'
            nfa2 = pop!(nfaStack)
            nfa1 = pop!(nfaStack)
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            initial.edge2 = nfa2.initial
            nfa1.accept.edge1 = accept
            nfa2.accept.edge1 = accept
            push!(nfaStack, NFA(initial, accept))
        elseif c == '+'
            nfa1 = pop!(nfaStack)
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            push!(nfaStack, NFA(initial, accept))
        elseif c == '?'
            nfa1 = pop!(nfaStack)
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = accept
            push!(nfaStack, NFA(initial, accept))
        else  # Literal character
            initial = State(c)
            accept = State()
            initial.edge1 = accept
            push!(nfaStack, NFA(initial, accept))
        end
    end
    return pop!(nfaStack)
end

function matchRegex(infix, s)
    postfix = shunt(infix)
    # Uncomment the next line to see the postfix expression
    # print("Postfix:", postfix)

    nfa = compileRegex(postfix)

    current = Set{State}(followes(nfa.initial))
    nextStates = Set{State}()

    for c in s
        for state in current
            if state.label == c
                follow = followes(state.edge1)
                union!(nextStates, follow)
            end
        end
        current = nextStates
        nextStates = Set{State}()
    end
    return nfa.accept ∈ current
end

const infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"]
const strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"]

println("Pattern      String  Matched?\n", "_"^30)
for infix in infixes
    for s in strings
        println(rpad(infix, 14), rpad(s, 8), matchRegex(infix, s))
    end
    println()
end
