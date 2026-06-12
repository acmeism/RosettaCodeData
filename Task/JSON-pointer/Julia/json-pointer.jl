""" rosettacode.org/wiki/JSON_pointer """

struct JSON_Pointer
    tokens::Vector{String}
end
JSON_Pointer(s::AbstractString) = JSON_Pointer(jp_parse(s))

resolve(p::JSON_Pointer, data) = reduce(getitem, p.tokens, init=data)

function jp_unencode_join(p::JSON_Pointer)
    isempty(p.tokens) && return ""
    return "/" * mapreduce(x -> replace(replace(x, "~" => "~0"), "/" => "~1"),
        (s1, s2) -> s1 * "/" * s2, p.tokens)
end

Base.print(io::IO, p::JSON_Pointer) = print(io, jp_unencode_join(p))

function jp_parse(s::AbstractString)
    if isempty(s)
        return String[]
    elseif s[begin] != '/'
        error("Non-empty JSON pointers must begin with /")
    else
        return map(x -> replace(replace(x, "~1" => "/"), "~0" => "~"),
            split(s, "/"))[begin+1:end]
    end
end

"""
NOTE:
    - to keep with the JavaScript convention, arrays are 0-based
    - string primitives "have own" indices and `length`.
    - Arrays have a `length` property.
    - A property might exist with the value `undefined`.
    - obj[1] is equivalent to obj["1"].
"""
getitem(obj::Vector, token::Integer) = obj[token+1]
getitem(obj::Vector, token::AbstractString) = obj[parse(Int, token)+1]
getitem(obj::Dict, token) = obj[token]

const doc = Dict(
    "wiki" => Dict(
        "links" => [
            "https://rosettacode.org/wiki/Rosetta_Code",
            "https://discord.com/channels/1011262808001880065",
        ],
    ),
    "" => "Rosetta",
    " " => "Code",
    "g/h" => "chrestomathy",
    "i~j" => "site",
    "abc" => ["is", "a"],
    "def" => Dict("" => "programming"),
)

const examples = [
    "",
    "/",
    "/ ",
    "/abc",
    "/def/",
    "/g~1h",
    "/i~0j",
    "/wiki/links/0",
    "/wiki/links/1",
    "/wiki/links/2",
    "/wiki/name",
    "/no/such/thing",
    "bad/pointer",
]

for ex in examples
    try
        pointer = JSON_Pointer(ex)
        result = resolve(pointer, doc)
        println("{$ex} -> {$result}")
    catch y
        println("Error: $ex does not exist: $y")
    end
end
