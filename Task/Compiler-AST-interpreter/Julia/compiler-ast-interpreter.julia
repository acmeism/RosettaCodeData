struct Anode
    node_type::String
    left::Union{Nothing, Anode}
    right::Union{Nothing, Anode}
    value::Union{Nothing, String}
end

make_leaf(t, v) = Anode(t, nothing, nothing, v)
make_node(t, l, r) = Anode(t, l, r, nothing)

const OP2 = Dict("Multiply" => "*", "Divide" => "/", "Mod" => "%", "Add" => "+", "Subtract" => "-",
                 "Less" => "<", "Greater" => ">", "LessEqual" => "<=", "GreaterEqual" => ">=",
                 "Equal" => "==", "NotEqual" => "!=", "And" => "&&", "Or" => "||")
const OP1 = Dict("Not" => "!", "Minus" => "-")

tobool(i::Bool) = i
tobool(i::Int) = (i != 0)
tobool(s::String) = eval(Symbol(s)) != 0

const stac = Vector{Any}()

function call2(op, x, y)
    if op in ["And", "Or"]
        x, y = tobool(x), tobool(y)
    end
    eval(Meta.parse("push!(stac, $(x) $(OP2[op]) $(y))"))
    return Int(floor(pop!(stac)))
end

call1(op, x) = (if op in ["Not"] x = tobool(x) end; eval(Meta.parse("$(OP1[op]) $(x)")))
evalpn(op, x, y = nothing) = (haskey(OP2, op) ? call2(op, x, y) : call1(op, x))

function load_ast(io)
    line = strip(readline(io))
    line_list = filter(x -> x != nothing, match(r"(?:(\w+)\s+(\d+|\w+|\".*\")|(\w+|;))", line).captures)
    text = line_list[1]
    if text == ";"
        return nothing
    end
    node_type = text
    if length(line_list) > 1
        return make_leaf(line_list[1], line_list[2])
    end
    left = load_ast(io)
    right = load_ast(io)
    return make_node(line_list[1], left, right)
end

function interp(x)
    if x == nothing return nothing
    elseif x.node_type == "Integer" return parse(Int, x.value)
    elseif x.node_type == "Identifier" return "_" * x.value
    elseif x.node_type == "String" return replace(replace(x.value, "\"" => ""), "\\n" => "\n")
    elseif x.node_type == "Assign" s = "$(interp(x.left)) = $(interp(x.right))"; eval(Meta.parse(s)); return nothing
    elseif x.node_type in keys(OP2) return evalpn(x.node_type, interp(x.left), interp(x.right))
    elseif x.node_type in keys(OP1) return evalpn(x.node_type, interp(x.left))
    elseif x.node_type ==  "If" tobool(eval(interp(x.left))) ? interp(x.right.left) : interp(x.right.right); return nothing
    elseif x.node_type == "While" while tobool(eval(interp(x.left))) interp(x.right) end; return nothing
    elseif x.node_type == "Prtc" print(Char(eval(interp(x.left)))); return nothing
    elseif x.node_type == "Prti" s = interp(x.left); print((i = tryparse(Int, s)) == nothing ? eval(Symbol(s)) : i); return nothing
    elseif x.node_type == "Prts" print(eval(interp(x.left))); return nothing
    elseif x.node_type == "Sequence" interp(x.left); interp(x.right); return nothing
    else
        throw("unknown node type: $x")
    end
end

const testparsed = """
Sequence
Sequence
Sequence
Sequence
Sequence
;
Assign
Identifier    count
Integer       1
Assign
Identifier    n
Integer       1
Assign
Identifier    limit
Integer       100
While
Less
Identifier    n
Identifier    limit
Sequence
Sequence
Sequence
Sequence
Sequence
;
Assign
Identifier    k
Integer       3
Assign
Identifier    p
Integer       1
Assign
Identifier    n
Add
Identifier    n
Integer       2
While
And
LessEqual
Multiply
Identifier    k
Identifier    k
Identifier    n
Identifier    p
Sequence
Sequence
;
Assign
Identifier    p
NotEqual
Multiply
Divide
Identifier    n
Identifier    k
Identifier    k
Identifier    n
Assign
Identifier    k
Add
Identifier    k
Integer       2
If
Identifier    p
If
Sequence
Sequence
;
Sequence
Sequence
;
Prti
Identifier    n
;
Prts
String        \" is prime\\n\"
;
Assign
Identifier    count
Add
Identifier    count
Integer       1
;
Sequence
Sequence
Sequence
;
Prts
String        \"Total primes found: \"
;
Prti
Identifier    count
;
Prts
String        \"\\n\"
;  """

const lio = IOBuffer(testparsed)

interp(load_ast(lio))
