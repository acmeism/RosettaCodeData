mutable struct ComputerZero
    ip::Int
    ram::Vector{UInt8}
    accum::UInt8
    isready::Bool
end
function ComputerZero(program)
    memory = zeros(UInt8, 32)
    for i in 1:min(32, length(program))
        memory[i] = program[i]
    end
    return ComputerZero(1, memory, 0, true)
end

NOP(c) = (c.ip = mod1(c.ip + 1, 32))
LDA(c) = (c.accum = c.ram[c.ram[c.ip] & 0b00011111 + 1]; c.ip = mod1(c.ip + 1, 32))
STA(c) = (c.ram[c.ram[c.ip] & 0b00011111 + 1] = c.accum; c.ip = mod1(c.ip + 1, 32))
ADD(c) = (c.accum += c.ram[c.ram[c.ip] & 0b00011111 + 1]; c.ip = mod1(c.ip + 1, 32))
SUB(c) = (c.accum -= c.ram[c.ram[c.ip] & 0b00011111 + 1]; c.ip = mod1(c.ip + 1, 32))
BRZ(c) = (c.ip = (c.accum == 0) ? c.ram[c.ip] & 0b00011111 + 1 : mod1(c.ip + 1, 32))
JMP(c) = (c.ip = c.ram[c.ip] & 0b00011111 + 1)
STP(c) = (println("Program completed with accumulator value $(c.accum).\n"); c.isready = false)

const step = [NOP, LDA, STA, ADD, SUB, BRZ, JMP, STP]
const instructions = ["NOP", "LDA", "STA", "ADD", "SUB", "BRZ", "JMP", "STP"]
const assemblywords = Dict(s => i - 1 for (i, s) in pairs(instructions))

function run(compzero::ComputerZero, debug = false)
    while compzero.isready
        instruction = compzero.ram[compzero.ip]
        opcode, operand =  instruction >> 5 + 1, instruction & 0b00011111
        debug && println("op $(instructions[opcode]), operand $operand")
        step[opcode](compzero)
    end
    return compzero.accum
end
run(program::Vector, debug = false) = run(ComputerZero(program), debug)

function compile(text::String)
    bin, lines = UInt8[], 0
    for line in strip.(split(text, "\n"))
        lines += 1
        if isempty(line)
           push!(bin, 0)
        elseif (m = match(r"(\w\w\w)\s+(\d\d?)", line)) != nothing
            push!(bin, UInt8((assemblywords[m.captures[1]] << 5) | parse(UInt8, m.captures[2])))
        elseif (m = match(r"(\w\w\w)", line)) != nothing
            push!(bin, UInt8(assemblywords[m.match] << 5))
        elseif (m = match(r"\d\d?", line)) != nothing
                push!(bin, parse(UInt8, m.match))
        else
            error("Compilation error at line $lines: error parsing <$line>")
        end
    end
    println("Compiled $lines lines.")
    return bin
end

const testprograms = [
    """
        LDA 3
        ADD 4
        STP
        2
        2
    """,
    """
        LDA 12
        ADD 10
        STA 12
        LDA 11
        SUB 13
        STA 11
        BRZ 8
        JMP 0
        LDA 12
        STP
        8
        7
        0
        1
    """,
    """
        LDA 14
        STA 15
        ADD 13
        STA 14
        LDA 15
        STA 13
        LDA 16
        SUB 17
        BRZ 11
        STA 16
        JMP 0
        LDA 14
        STP
        1
        1
        0
        8
        1
    """,
    """
        LDA 13
        ADD 15
        STA 5
        ADD 16
        STA 7
        NOP
        STA 14
        NOP
        BRZ 11
        STA 15
        JMP 0
        LDA 14
        STP
        LDA 0
        0
        28
        1



        6
        0
        2
        26
        5
        20
        3
        30
        1
        22
        4
        24
    """,
    """
        0
        0
        STP
        NOP
        LDA 3
        SUB 29
        BRZ 18
        LDA 3
        STA 29
        BRZ 14
        LDA 1
        ADD 31
        STA 1
        JMP 2
        LDA 0
        ADD 31
        STA 0
        JMP 2
        LDA 3
        STA 29
        LDA 0
        ADD 30
        ADD 3
        STA 0
        LDA 1
        ADD 30
        ADD 3
        STA 1
        JMP 2
        0
        1
        3
    """
]

for t in testprograms
    run(compile(t))
end
