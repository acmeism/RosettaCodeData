"""
Convert a fraction to its decimal representation, identifying repeating portions.
Returns a string with the repeating part in parentheses.
"""
function find_repeating_decimal(numerator::Integer, denominator::Integer; digitlimit = 100)
    denominator == 0 && error("Denominator cannot be zero")
    # Save sign and work with absolute values
    sign = (numerator < 0) ⊻ (denominator < 0) ? "-" : ""
    numerator = abs(BigInt(numerator))
    denominator = abs(BigInt(denominator))
    # Integer part
    integer_part, remainder = divrem(numerator, denominator)
    remainder == 0 && return "$(sign)$(integer_part)"
    # Track remainders and their positions to detect cycles
    remainder_positions = Dict{BigInt, Int}()
    decimal_digits = Char[]
    position = 0
    while remainder != 0 && !haskey(remainder_positions, remainder) && position < digitlimit
        remainder_positions[remainder] = position
        remainder *= 10
        digit, remainder = divrem(remainder, denominator)
        push!(decimal_digits, Char('0' + digit))
        position += 1
    end
    if position >= digitlimit
        return "$(sign)$(integer_part).$(String(decimal_digits)) (truncated, nonrepeating to $digitlimit digits)"
    end
    remainder == 0 && return "$(sign)$(integer_part).$(String(decimal_digits))"
    repeat_start = remainder_positions[remainder]
    non_repeating = String(decimal_digits[1:repeat_start])
    repeating = String(decimal_digits[repeat_start+1:end])
    return repeat_start == 0 ?
        "$(sign)$(integer_part).($(repeating))" :
        "$(sign)$(integer_part).$(non_repeating)($(repeating))"
end

function testrationalcalculator()
    println("Enter rational expressions (e.g. 1//3, 2//5 + 1//4, etc.)")
    println("Use '@' to refer to the previous result. Enter an empty line to quit.")
    this = nothing
    while true
        print("> ")
        line = readline(stdin, keep=true)
        line = strip(line)
        isempty(line) && break
        # substitute '@' with previous result
        if this !== nothing
            line = replace(line, "@" =>"($this)")
        end
        # replace all integer literals with BigInt rationals
        line = replace(line, r"\b([\-\+\d]+)\b" => s"\1//BigInt(1)")
        val = eval(Meta.parse(line))
        this = rationalize(BigFloat(val)) |> x -> Rational{BigInt}(x)
        println(find_repeating_decimal(numerator(this), denominator(this)))
    end
end

testrationalcalculator()
