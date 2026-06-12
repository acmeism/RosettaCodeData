function substituteinnerparentheses(s, subs)
    ((i = findlast('(', s)) == nothing) && return (s, false)
    ((j = findfirst(')', s[i:end])) == nothing) && return (s, false)
    okparse(s[i+1:j+i-2]) || return (s, false)
    return s[1:i-1] * " " * subs * " " * s[j+i:end], true
end

function okparse(s)
    while findfirst('(', s) != nothing
        s, okinparentheses = substituteinnerparentheses(s, "true")
        okinparentheses || return false
    end
    s = strip(s)
    # Julia allows expressions like 2 + + + 3, or like true = not false, but these are not allowed here
    # = or < can be used only once within parentheses
    if occursin(r"(and|or|[\=\<\+\-\*\/])\s*(and|or|[\=\<\+\-\*\/])", s) ||
        occursin(r"(^(and|^or|^[\=\<\+\-\*\/]))|((and|or|[\=\<\+\-\*\/])$)", s) ||
        occursin(r"(\=|\<)\s*not\s", s) || count(c -> c == '=' || c == '<', s) > 1
        return false
    end
    # Julia allows ., ,, ; and operators like % but these are not allowed here
    # permitted: -+*/ true false and or not, ascii identifiers, and integers
    for item in split(s, r"\s+")
        !occursin(
            r"^[a-zA-Z][a-zA-Z_0-9]*$|^\d+$|^true$|^false$|^or$|^and$|^not$|^\=$|^\<$|^\+$|^-$|^\*$|^\/$",
            item) && return false
    end
    # change and, or, and not to the corresponding Julia operators
    s = replace(replace(replace(s, "and" => "&&"), "or" => "||"), "not" => "!")
    try
        # Use Julia's parser, which will throw exception if it parses an error
        Meta.parse(s)
    catch
        return false
    end
    return true
end

teststatements = [
" not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
" and 3 < 2",
"not 7 < 2",
"4 * (32 - 16) + 9 = 73",
"235 76 + 1",
"true or false = not true",
"not true = false",
"2 < 5 < 9"
]

for s in teststatements
    println("The compiler parses the statement { $s } and outputs: ", okparse(s))
end
