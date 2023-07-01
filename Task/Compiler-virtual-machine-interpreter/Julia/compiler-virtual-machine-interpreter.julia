mutable struct VM32
    code::Vector{UInt8}
    stack::Vector{Int32}
    data::Vector{Int32}
    strings::Vector{String}
    offsets::Vector{Int32}
    lastargs::Vector{Int32}
    ip::Int32
    VM32() = new(Vector{UInt8}(), Vector{Int32}(), Vector{Int32}(),
                 Vector{String}(), Vector{Int32}(), Vector{Int32}(), 1)
end

halt, add, sub, mul, Div, mod, not, neg, and, or, lt, gt, le, ge, ne, eq, prts,
    prti, prtc, store, Fetch, push, jmp, jz = UInt8.(collect(1:24))

function assemble(io)
    vm = VM32()
    header = readline(io)
    datasize, nstrings = match(r"\w+:\s*(\d+)\s+\w+:\s*(\d+)", header).captures
    vm.data = zeros(Int32, parse(Int, datasize) + 4)
    for i in 1:parse(Int, nstrings)
        line = replace(strip(readline(io), ['"', '\n']), r"\\." => x -> x[end] == 'n' ? "\n" : string(x[end]))
        push!(vm.strings, line)
    end
    while !eof(io)
        line = readline(io)
        offset, op, arg1, arg2 = match(r"(\d+)\s+(\w+)\s*(\S+)?\s*(\S+)?", line).captures
        op = op in ["fetch", "div"] ? uppercasefirst(op) : op
        push!(vm.code, eval(Symbol(op)))
        if arg1 != nothing
            v = parse(Int32, strip(arg1, ['[', ']', '(', ')']))
            foreach(x -> push!(vm.code, x), reinterpret(UInt8, [v]))
        end
        if arg2 != nothing
            push!(vm.lastargs, (x = tryparse(Int32, arg2)) == nothing ? 0 : x)
        end
        push!(vm.offsets, parse(Int32, offset))
    end
    vm
end

function runvm(vm)
    value() = (x = vm.ip; vm.ip += 4; reinterpret(Int32, vm.code[x:x+3])[1])
    tobool(x) = (x != 0)
    ops = Dict(
        halt  => () -> exit(),
        add   => () -> begin vm.stack[end-1] += vm.stack[end]; pop!(vm.stack); vm.stack[end] end,
        sub   => () -> begin vm.stack[end-1] -= vm.stack[end]; pop!(vm.stack); vm.stack[end] end,
        mul   => () -> begin vm.stack[end-1] *= vm.stack[end]; pop!(vm.stack); vm.stack[end] end,
        Div   => () -> begin vm.stack[end-1] /= vm.stack[end]; pop!(vm.stack); vm.stack[end] end,
        mod   => () -> begin vm.stack[end-1] %= vm.stack[1]; pop!(vm.stack); vm.stack[end] end,
        not   => () -> vm.stack[end] = vm.stack[end] ? 0 : 1,
        neg   => () -> vm.stack[end] = -vm.stack[end],
        and   => () -> begin vm.stack[end-1] = tobool(vm.stack[end-1]) && tobool(vm.stack[end]) ? 1 : 0; pop!(vm.stack); vm.stack[end] end,
        or    => () -> begin vm.stack[end-1] = tobool(vm.stack[end-1]) || tobool(vm.stack[end]) ? 1 : 0; pop!(vm.stack); vm.stack[end] end,
        lt    => () -> begin x = (vm.stack[end-1] < vm.stack[end] ? 1 : 0); pop!(vm.stack); vm.stack[end] = x end,
        gt    => () -> begin x = (vm.stack[end-1] > vm.stack[end] ? 1 : 0); pop!(vm.stack); vm.stack[end] = x end,
        le    => () -> begin x = (vm.stack[end-1] <= vm.stack[end] ? 1 : 0); pop!(vm.stack); vm.stack[end] = x end,
        ge    => () -> begin x = (vm.stack[end-1] >= vm.stack[end] ? 1 : 0); pop!(vm.stack); vm.stack[end] = x end,
        ne    => () -> begin x = (vm.stack[end-1] != vm.stack[end] ? 1 : 0); pop!(vm.stack); vm.stack[end] = x end,
        eq    => () -> begin x = (vm.stack[end-1] == vm.stack[end] ? 1 : 0); pop!(vm.stack); vm.stack[end] = x end,
        prts  => () -> print(vm.strings[pop!(vm.stack) + 1]),
        prti  => () -> print(pop!(vm.stack)),
        prtc  => () -> print(Char(pop!(vm.stack))),
        store => () -> vm.data[value() + 1] = pop!(vm.stack),
        Fetch => () -> push!(vm.stack, vm.data[value() + 1]),
        push  => () -> push!(vm.stack, value()),
        jmp   => () -> vm.ip += value(),
        jz    => () -> if pop!(vm.stack) == 0 vm.ip += value() else vm.ip += 4 end)
    vm.ip = 1
    while true
        op = vm.code[vm.ip]
        vm.ip += 1
        ops[op]()
    end
end

const testasm = """
Datasize: 1 Strings: 2
"count is: "
"\\n"
    0 push  1
    5 store [0]
   10 fetch [0]
   15 push  10
   20 lt
   21 jz     (43) 65
   26 push  0
   31 prts
   32 fetch [0]
   37 prti
   38 push  1
   43 prts
   44 fetch [0]
   49 push  1
   54 add
   55 store [0]
   60 jmp    (-51) 10
   65 halt   """

const iob = IOBuffer(testasm)
const vm = assemble(iob)
runvm(vm)
