import Base.show

@enum Move Left=1 Stay Right

mutable struct MachineState
    state::String
    tape::Dict{Int, String}
    headpos::Int
end

struct Rule
    instate::String
    s1::String
    s2::String
    move::Move
    outstate::String
end

struct Program
    title::String
    initial::String
    final::String
    blank::String
    rules::Vector{Rule}
end

const testprograms = [
    (Program("Simple incrementer", "q0", "qf", "B",
        [Rule("q0", "1", "1", Right, "q0"), Rule("q0", "B", "1", Stay, "qf")]),
     Dict(1 =>"1", 2 => "1", 3 => "1"), true),
    (Program("Three-state busy beaver", "a", "halt", "0",
        [Rule("a", "0", "1", Right, "b"), Rule("a", "1", "1", Left, "c"),
         Rule("b", "0", "1", Left, "a"), Rule("b", "1", "1", Right, "b"),
         Rule("c", "0", "1", Left, "b"), Rule("c", "1", "1", Stay, "halt")]),
     Dict(), true),
    (Program("Five-state busy beaver", "A", "H", "0",
        [Rule("A", "0", "1", Right, "B"), Rule("A", "1", "1", Left, "C"),
         Rule("B", "0", "1", Right, "C"), Rule("B", "1", "1", Right, "B"),
         Rule("C", "0", "1", Right, "D"), Rule("C", "1", "0", Left, "E"),
         Rule("D", "0", "1", Left, "A"), Rule("D", "1", "1", Left, "D"),
         Rule("E", "0", "1", Stay, "H"), Rule("E", "1", "0", Left, "A")]),
     Dict(), false)]

function show(io::IO, mstate::MachineState)
    ibracket(i, curpos, val) = (i == curpos) ? "[$val]" : " $val "
    print(io, rpad("($(mstate.state))", 12))
    for i in sort(collect(keys(mstate.tape)))
        print(io, "   $(ibracket(i, mstate.headpos, mstate.tape[i]))")
    end
end

function turing(program, tape, verbose)
    println("\n$(program.title)")
    verbose && println(" State       \tTape [head]\n--------------------------------------------------")
    mstate = MachineState(program.initial, tape, 1)
    stepcount = 0
    while true
        if !haskey(mstate.tape, mstate.headpos)
            mstate.tape[mstate.headpos] = program.blank
        end
        verbose && println(mstate)
        for rule in program.rules
            if rule.instate == mstate.state && rule.s1 == mstate.tape[mstate.headpos]
                mstate.tape[mstate.headpos] = rule.s2
                if rule.move == Left
                    mstate.headpos -= 1
                elseif rule.move == Right
                    mstate.headpos += 1
                end
                mstate.state = rule.outstate
                break
            end
        end
        stepcount += 1
        if mstate.state == program.final
            break
        end
    end
    verbose && println(mstate)
    println("Total steps: $stepcount")
end

for (prog, tape, verbose) in testprograms
        turing(prog, tape, verbose)
end
