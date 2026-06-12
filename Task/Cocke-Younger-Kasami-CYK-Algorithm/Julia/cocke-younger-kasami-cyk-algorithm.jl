""" rosettacode.org/wiki/Cocke-Younger-Kasami_(CYK)_Algorithm """

""" CYK parser implementation. Returns true if `w` is valid CYK under `r` rules. """
function cyk_parse(w, r, startcode = "NP")
	n = length(w)
	t = [Set{String}() for _ in 1:n, _ in 1:n]
	for j in 1:n
		for (lhs, rules) in r
			for rhs in rules
				if length(rhs) == 1 && rhs[1] == w[j]
					push!(t[j, j], lhs)
				end
			end
		end
		for i in j:-1:1
			for k in i:(j-1)
				for (lhs, rules) in r
					for rhs in rules
						if length(rhs) == 2 &&
						   rhs[1] in t[i, k] &&
						   rhs[2] in t[k+1, j]
							push!(t[i, j], lhs)
						end
					end
				end
			end
		end
	end
	return startcode in t[1, n]
end

""" Test the CYK parser with a sample grammar and input string.
start code: "NP"
non_terminals: ["NP", "Nom", "Det", "AP", "Adv", "A"]
terminals: ["book", "orange", "man", "tall", "heavy", "very", "muscular"]
"""
function testCYK()
    r = Dict(
        "NP" => [["Det", "Nom"]],
        "Nom" => [
            ["AP", "Nom"],
            ["book"],
            ["orange"],
            ["man"],
        ],
        "AP" => [
            ["Adv", "A"],
            ["heavy"],
            ["orange"],
            ["tall"],
        ],
        "Det" => [["a"]],
        "Adv" => [["very"], ["extremely"]],
        "A" => [
            ["heavy"],
            ["orange"],
            ["tall"],
            ["muscular"]],
    )
    w = split("a very heavy orange book")
    return cyk_parse(w, r, "NP")
end

@show testCYK()
