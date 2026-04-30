using Printf

const UNITS_TO_MULTIPLIERS = [
    "arshin" => 0.7112, "centimeter" => 0.01,     "diuym"   => 0.0254,
    "fut"    => 0.3048, "kilometer"  => 1000.0,   "liniya"  => 0.00254,
    "meter"  => 1.0,    "milia"      => 7467.6,   "piad"    => 0.1778,
    "sazhen" => 2.1336, "tochka"     => 0.000254, "vershok" => 0.04445,
    "versta" => 1066.8
]

function oldrussianunits()
    @assert length(ARGS) == 2 "need two arguments - number then units"
    value = tryparse(Float64, ARGS[1])
    @assert !isnothing(value) "first argument must be a number representable as a 64 bit float"
    unit = ARGS[2]
    idx = findfirst(x -> x[1] == unit, UNITS_TO_MULTIPLIERS)
    @assert !isnothing(idx) "only know the following units:\n" * join(map(first, UNITS_TO_MULTIPLIERS), ", ")
    println("$value $unit to:")
    for (unt, mlt) in UNITS_TO_MULTIPLIERS
        @printf("  %10s: %g\n", unt, value * UNITS_TO_MULTIPLIERS[idx][2] / mlt)
    end
end

oldrussianunits()
