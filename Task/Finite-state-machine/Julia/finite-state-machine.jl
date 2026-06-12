abstract type State end

struct Ready <: State
    transitiontable::Dict
    implicit::Union{State, Nothing}
    prompt::String
end

struct Waiting <: State
    transitiontable::Dict
    implicit::Union{State, Nothing}
    prompt::String
end

struct Dispense <: State
    transitiontable::Dict
    implicit::Union{State, Nothing}
    prompt::String
end

struct Refunding <: State
    transitiontable::Dict
    implicit::Union{State, Nothing}
    prompt::String
end

struct Exit <: State
    transitiontable::Dict
    implicit::Union{State, Nothing}
    prompt::String
end

Ready() = Ready(Dict("deposit" => Waiting, "quit" => Exit), nothing, "Vending machine is ready.")
Waiting() = Waiting(Dict("select" => Dispense, "refund" => Refunding), nothing, "Waiting with funds.")
Dispense() = Dispense(Dict("remove" => Ready), nothing, "Thank you! Product dispensed.")
Refunding() = Refunding(Dict(), Ready(), "Please take refund.")
Exit() = Exit(Dict(), nothing, "Halting.")

makeinstance(Ready) = Ready()
makeinstance(Waiting) = Waiting()
makeinstance(Dispense) = Dispense()
makeinstance(Refunding) = Refunding()
makeinstance(Exit) = Exit()

function queryprompt(query, typ)
    print(query, ": ")
    entry = uppercase(strip(readline(stdin)))
    return (typ <: Integer) ? parse(Int, entry) :
        (typ <: Vector) ? map(x -> parse(Int, x), split(entry, r"\s+")) :
        entry
end

function promptinput(state)
    choices = [(s[1], s[2:end]) for s in keys(state.transitiontable)]
    print(state.prompt, join([" ($(w[1]))$(w[2])" for w in choices], ","), ": ")
    while true
        choice = readline()
        if !isempty(choice) && (x = findfirst(s -> s[1] == choice[1], choices)) != nothing
            return state.transitiontable[join(choices[x], "")]
        end
    end
end

quitting(s::State) = false
quitting(s::Exit) = true

function runsim(state)
    while true
        if state.implicit != nothing
            println(state.prompt)
            state = state.implicit
        elseif quitting(state)
            println(state.prompt)
            break
        else
            state = makeinstance(promptinput(state))
        end
    end
end

runsim(Ready())
