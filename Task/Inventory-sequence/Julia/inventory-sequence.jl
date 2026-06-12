""" rosettacode.org/wiki/Inventory_sequence """

using Printf
using Counters
using Plots

struct InventorySequence
    inventory::Counter{Int}
    InventorySequence() = new(counter([0]))
end

function Base.iterate(i::InventorySequence, num = 0)
    nextval = i.inventory[num]
    num = nextval == 0 ? 0 : num + 1
    i.inventory[nextval] += 1
    return nextval, num
end

const thresholds = [1000 * j for j in 1:10]
const toplot = Int[]

for (i, n) in enumerate(InventorySequence())
    if i <= 100
        print(rpad(n, 4), i % 20 == 0 ? "\n" : "")
    elseif n >= thresholds[begin]
        @printf("First element >= %d5: %d5 in position %d.\n", popfirst!(thresholds), n, i)
        length(thresholds) == 0 && break
    end
    length(toplot) < 10000 && push!(toplot, n)
end

plot(toplot)
