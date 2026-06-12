"""
ASCII code	Symbols used
0	        |@
1 - 26	    |letter eg |A (or |a) = ASCII 1, |M (or |m) = ASCII 13
27	        |[ or |{
28	        |\
29	        |] or |}
30	        |^ or |~
31	        |_ or |' (grave accent)
32 - 126	keyboard character, except for:
"	        |"
|	        ||
<	        |<
127	        |?
128 - 255	|!coded symbol eg ASCII 128 = |!|@ ASCII 129 = |!|A

See also www.riscos.com/support/developers/prm/conversions.html
"""

"""
    function GSTrans_encode

    3 methods.

    Encode a string by converting a potentially Unicode string to codeunit bytes and
    then to a vector of ascii Chars, then passing to the encoding routine for the vector.

    Encode a Vector of Char as its individual Chars and concatenating results.

    Encode a single Char as a GSTRans string of 1 or more chars.
    To avoid Unicode multibyte glitches, throw an assertion error if any Chars
    are multibyte (so, 0 <= integer value of Char c <= 255).
"""
GSTrans_encode(str::AbstractString) = GSTrans_encode(Char.(transcode(UInt8, str)))
GSTrans_encode(a::Vector{Char}) = String(mapreduce(GSTrans_encode, vcat, a, init = Char[]))
function GSTrans_encode(c::Char)
    i = Int(c)
    @assert 0 <= i <= 255 "Char value of $c, $i, is out of range"
    resultchars = Char[]
    if 0 <= i <= 31
        push!(resultchars, '|', Char(64 + i))
    elseif c == '"'
        push!(resultchars, '|', '"')
    elseif c == '|'
        push!(resultchars, '|', '|')
    elseif i == 127
        push!(resultchars, '|', '?')
    elseif 128 <= i <= 255 # |! then recurse after subtracting 128
        push!(resultchars, '|', '!', GSTrans_encode(Char(i - 128))...)
    else
        push!(resultchars, c)
    end
    return resultchars
end

"""
    function GSTrans_decode(str::AbstractString)

    Decode a GSTrans coded string back to original format. If decoding results
    in a negative value for the result due to encoding errors such as "|1" will
    substitute the char without the subtraction of 64 from the | bar, as in the
    Wren and Phix examples, so that "|1" becomes '1'.
"""
function GSTrans_decode(str::AbstractString)
    result = UInt8[]
    gotbar, gotbang, bangadd = false, false, 0
    for c in str
        if gotbang
            if c == '|'
                bangadd = 128
                gotbar = true
            else
                push!(result, Char(Int(c) + 128))
            end
            gotbang = false
        elseif gotbar
            if c == '?'
                push!(result, Char(127 + bangadd))
            elseif c == '!'
                gotbang = true
            elseif c == '|' || c == '"' || c == '<'
                push!(result, Char(Int(c) + bangadd))
            elseif c == '[' || c == '{'
                push!(result, Char(27 + bangadd))
            elseif c == '\\'
                push!(result, Char(28 + bangadd))
            elseif c == ']' || c == '}'
                push!(result, Char(29 + bangadd))
            elseif c == '^' || c == '~'
                push!(result, Char(30 + bangadd))
            elseif c == '_' || c == '`'
                push!(result, Char(31 + bangadd))
            else
                i = Int(uppercase(c)) - 64 + bangadd
                push!(result, i >= 0 ? Char(i) : c)
            end
            gotbar, bangadd = false, 0
        elseif c == '|'
                gotbar = true
        else
            push!(result, Char(c))
        end
    end
    return String(result)
end

const TESTS = ["ALERT|G", "wert↑"]
const RAND_TESTS = [String(Char.(rand(0:255, 10))) for _ in 1:8]
const DECODE_TESTS = ["|LHello|G|J|M", "|m|j|@|e|!t|m|!|?", "abc|1de|5f"]

for t in [TESTS; RAND_TESTS]
    encoded = GSTrans_encode(t)
    decoded = GSTrans_decode(encoded)
    println("String $t encoded is: $encoded, decoded is: $decoded.")
    @assert t == decoded
end

for enc in DECODE_TESTS
    print("Encoded string $enc decoded is: ")
    display(GSTrans_decode(enc))
end
