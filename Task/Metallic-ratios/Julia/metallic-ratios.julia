using Formatting
import Base.iterate, Base.IteratorSize, Base.IteratorEltype, Base.Iterators.take

const metallicnames = ["Platinum", "Golden", "Silver", "Bronze", "Copper", "Nickel",
    "Aluminium", "Iron", "Tin", "Lead"]

struct Lucas b::Int end
Base.IteratorSize(s::Lucas) = Base.IsInfinite()
Base.IteratorEltype(s::Lucas) = BigInt
Base.iterate(s::Lucas, (x1, x2) = (big"1", big"1")) = (t = x2 * s.b + x1; (x1, (x2, t)))

printlucas(b, len=15) = (for i in take(Lucas(b), len) print(i, ", ") end; println("..."))

function lucasratios(b, len)
	iter = BigFloat.(collect(take(Lucas(b), len + 1)))
	return map(i -> iter[i + 1] / iter[i], 1:length(iter)-1)
end		

function metallic(b, dplaces=32)
    setprecision(dplaces * 5)
    ratios, err = lucasratios(b, dplaces * 50), BigFloat(10)^(-dplaces)
    errors = map(i -> abs(ratios[i + 1] - ratios[i]), 1:length(ratios)-1)
    iternum = findfirst(x -> x < err, errors)
    println("After $(iternum + 1) iterations, the value of ",
		format(ratios[iternum + 1], precision=dplaces),
		" is stable to $dplaces decimal places.\n")
end

for (b, name) in enumerate(metallicnames)
    println("The first 15 elements of the Lucas sequence named ",
            metallicnames[b], " and b of $(b - 1) are:")
    printlucas(b - 1)
    metallic(b - 1)
end
println("Golden ratio to 256 decimal places:")
metallic(1, 256)
