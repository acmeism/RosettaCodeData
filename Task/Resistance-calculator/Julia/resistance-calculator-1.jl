using Formatting
import Base.+, Base.*

mutable struct Resistor
    operator::Char
    voltage::Float64
    resistance::Float64
    a::Union{Resistor, Nothing}
    b::Union{Resistor, Nothing}
end

function res(r::Resistor)
    if r != nothing
        if r.operator == '+'
            return res(r.a) + res(r.b)
        elseif r.operator == '*'
            return 1 / ((1 / res(r.a)) + (1 / res(r.b)))
        end
        return r.resistance
    end
end

function setvoltage(r, voltage)
    if r != nothing
        if r.operator == '+'
            ra = res(r.a)
            rb = res(r.b)
            setvoltage(r.a, voltage * ra / (ra + rb))
            setvoltage(r.b, voltage * rb / (ra + rb))
        elseif r.operator == '*'
            setvoltage(r.a, voltage)
            setvoltage(r.b, voltage)
        end
        r.voltage = voltage
    end
end

current(r) = r.voltage / res(r)

effect(r) = r.voltage * current(r)

function report(r, level=1)
    nfmt(x::Real) = rpad(format(x, precision=3), 12)
    afmt(arr::Vector) = join(map(nfmt, arr), "| ")
    println(afmt([res(r), r.voltage, current(r), effect(r)]), "| "^level, r.operator)
    if r.a != nothing
        report(r.a, level + 1)
    end
    if r.b != nothing
        report(r.b, level + 1)
    end
end

Base.:+(a::Resistor, b::Resistor) = Resistor('+',  0.0, 0.0, a, b)
Base.:*(a::Resistor, b::Resistor) = Resistor('*',  0.0, 0.0, a, b)

(R1, R2, R3, R4, R5, R6, R7, R8, R9, R10) =
    map(r -> Resistor('r', 0.0, r, nothing, nothing), [6, 8, 4, 8, 4, 6, 8, 10, 6, 2])

node = ((((R8 + R10) * R9 + R7) * R6 + R5) * R4 + R3) * R2 + R1
setvoltage(node, 18)

println("   Ohm        Volt          Ampere        Watt        Network tree")
report(node)
