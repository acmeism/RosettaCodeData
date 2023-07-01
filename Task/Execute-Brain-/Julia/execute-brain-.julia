using DataStructures

function execute(src)
    pointers = Dict{Int,Int}()
    stack    = Int[]
    for (ptr, opcode) in enumerate(src)
        if opcode == '[' push!(stack, ptr) end
        if opcode == ']'
            if isempty(stack)
                src = src[1:ptr]
                break
            end
            sptr = pop!(stack)
            pointers[ptr], pointers[sptr] = sptr, ptr
        end
    end
    if ! isempty(stack) error("unclosed loops at $stack") end
    tape = DefaultDict{Int,Int}(0)
    cell, ptr = 0, 1
    while ptr ≤ length(src)
        opcode = src[ptr]
        if     opcode == '>' cell += 1
        elseif opcode == '<' cell -= 1
        elseif opcode == '+' tape[cell] += 1
        elseif opcode == '-' tape[cell] -= 1
        elseif opcode == ',' tape[cell] = Int(read(STDIN, 1))
        elseif opcode == '.' print(STDOUT, Char(tape[cell]))
        elseif (opcode == '[' && tape[cell] == 0) ||
               (opcode == ']' && tape[cell] != 0) ptr = pointers[ptr]
        end
        ptr += 1
    end
end

const src = """\
    >++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]>.+++++++..+++.>
    >+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>.+++.------.--------.>>+.>++++."""
execute(src)
