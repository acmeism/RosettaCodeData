function ecainfinite(cells, rule, n)
    notcell(cell) = (cell == '1') ? '0' : '1'
    rulebits = reverse(string(rule, base = 2, pad = 8))
    neighbors2next = Dict(string(n - 1, base=2, pad=3) => rulebits[n] for n in 1:8)
    ret = String[]
    for i in 1:n
        push!(ret, cells)
        cells = notcell(cells[1])^2 * cells * notcell(cells[end])^2 # Extend/pad ends
        cells = join([neighbors2next[cells[i:i+2]] for i in 1:length(cells)-2], "")
    end
    ret
end

function testinfcells(lines::Integer)
    for rule in [90, 30]
        println("\nRule: $rule ($(string(rule, base = 2, pad = 8)))")
        s = ecainfinite("1", rule, lines)
        for i in 1:lines
            println("$i: ", " "^(lines - i), replace(replace(s[i], "0" => "."), "1" => "#"))
        end
    end
end

testinfcells(25)
