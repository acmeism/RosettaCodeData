using DataStructures

const unit2mult = Dict(
    "arshin" => 0.7112, "centimeter" => 0.01,     "diuym"   => 0.0254,
    "fut"    => 0.3048, "kilometer"  => 1000.0,   "liniya"  => 0.00254,
    "meter"  => 1.0,    "milia"      => 7467.6,   "piad"    => 0.1778,
    "sazhen" => 2.1336, "tochka"     => 0.000254, "vershok" => 0.04445,
    "versta" => 1066.8)

@assert length(ARGS) == 2 "need two arguments - number then units"

global value
try value = parse(Float64, ARGS[1])
catch error("first argument must be a (float) number") end

if isnull(value) error("first argument must be a (float) number") end
unit = ARGS[2]
@assert unit ∈ keys(unit2mult) "only know the following units:\n" * join(keys(unit2mult), ", ")

println("$value $unit to:")
for (unt, mlt) in sort(unit2mult)
    @printf("  %10s: %g\n", unt, value * unit2mult[unit] / mlt)
end
