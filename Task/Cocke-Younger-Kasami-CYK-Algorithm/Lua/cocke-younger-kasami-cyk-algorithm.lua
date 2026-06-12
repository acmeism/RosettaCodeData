-- rosettacode.org/wiki/Cocke-Younger-Kasami_(CYK)_Algorithm

-- CYK parser implementation. Returns true if w is valid CYK under r rules.
function cyk_parse(w, r, startcode)
    startcode = startcode or "NP"
    local n = #w

    -- Initialize table t as a 2D array of sets (represented as tables)
    local t = {}
    for i = 1, n do
        t[i] = {}
        for j = 1, n do
            t[i][j] = {}
        end
    end

    -- Main CYK algorithm
    for j = 1, n do
        -- Check for terminal rules
        for lhs, rules in pairs(r) do
            for _, rhs in ipairs(rules) do
                if #rhs == 1 and rhs[1] == w[j] then
                    t[j][j][lhs] = true
                end
            end
        end

        -- Check for non-terminal rules
        for i = j, 1, -1 do
            for k = i, j - 1 do
                for lhs, rules in pairs(r) do
                    for _, rhs in ipairs(rules) do
                        if #rhs == 2 then
                            local rhs1 = rhs[1]
                            local rhs2 = rhs[2]
                            if t[i][k][rhs1] and t[k + 1][j][rhs2] then
                                t[i][j][lhs] = true
                            end
                        end
                    end
                end
            end
        end
    end

    return t[1][n][startcode] == true
end

-- Test the CYK parser with a sample grammar and input string.
-- start code: "NP"
-- non_terminals: ["NP", "Nom", "Det", "AP", "Adv", "A"]
-- terminals: ["book", "orange", "man", "tall", "heavy", "very", "muscular"]
function testCYK()
    local r = {
        NP = {
            {"Det", "Nom"}
        },
        Nom = {
            {"AP", "Nom"},
            {"book"},
            {"orange"},
            {"man"}
        },
        AP = {
            {"Adv", "A"},
            {"heavy"},
            {"orange"},
            {"tall"}
        },
        Det = {
            {"a"}
        },
        Adv = {
            {"very"},
            {"extremely"}
        },
        A = {
            {"heavy"},
            {"orange"},
            {"tall"},
            {"muscular"}
        }
    }

    local w = {"a", "very", "heavy", "orange", "book"}
    return cyk_parse(w, r, "NP")
end

print("testCYK result:", testCYK())
