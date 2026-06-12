atomicMass = {
    ["H"]   =   1.008,
    ["He"]  =   4.002602,
    ["Li"]  =   6.94,
    ["Be"]  =   9.0121831,
    ["B"]   =  10.81,
    ["C"]   =  12.011,
    ["N"]   =  14.007,
    ["O"]   =  15.999,
    ["F"]   =  18.998403163,
    ["Ne"]  =  20.1797,
    ["Na"]  =  22.98976928,
    ["Mg"]  =  24.305,
    ["Al"]  =  26.9815385,
    ["Si"]  =  28.085,
    ["P"]   =  30.973761998,
    ["S"]   =  32.06,
    ["Cl"]  =  35.45,
    ["Ar"]  =  39.948,
    ["K"]   =  39.0983,
    ["Ca"]  =  40.078,
    ["Sc"]  =  44.955908,
    ["Ti"]  =  47.867,
    ["V"]   =  50.9415,
    ["Cr"]  =  51.9961,
    ["Mn"]  =  54.938044,
    ["Fe"]  =  55.845,
    ["Co"]  =  58.933194,
    ["Ni"]  =  58.6934,
    ["Cu"]  =  63.546,
    ["Zn"]  =  65.38,
    ["Ga"]  =  69.723,
    ["Ge"]  =  72.630,
    ["As"]  =  74.921595,
    ["Se"]  =  78.971,
    ["Br"]  =  79.904,
    ["Kr"]  =  83.798,
    ["Rb"]  =  85.4678,
    ["Sr"]  =  87.62,
    ["Y"]   =  88.90584,
    ["Zr"]  =  91.224,
    ["Nb"]  =  92.90637,
    ["Mo"]  =  95.95,
    ["Ru"]  = 101.07,
    ["Rh"]  = 102.90550,
    ["Pd"]  = 106.42,
    ["Ag"]  = 107.8682,
    ["Cd"]  = 112.414,
    ["In"]  = 114.818,
    ["Sn"]  = 118.710,
    ["Sb"]  = 121.760,
    ["Te"]  = 127.60,
    ["I"]   = 126.90447,
    ["Xe"]  = 131.293,
    ["Cs"]  = 132.90545196,
    ["Ba"]  = 137.327,
    ["La"]  = 138.90547,
    ["Ce"]  = 140.116,
    ["Pr"]  = 140.90766,
    ["Nd"]  = 144.242,
    ["Pm"]  = 145,
    ["Sm"]  = 150.36,
    ["Eu"]  = 151.964,
    ["Gd"]  = 157.25,
    ["Tb"]  = 158.92535,
    ["Dy"]  = 162.500,
    ["Ho"]  = 164.93033,
    ["Er"]  = 167.259,
    ["Tm"]  = 168.93422,
    ["Yb"]  = 173.054,
    ["Lu"]  = 174.9668,
    ["Hf"]  = 178.49,
    ["Ta"]  = 180.94788,
    ["W"]   = 183.84,
    ["Re"]  = 186.207,
    ["Os"]  = 190.23,
    ["Ir"]  = 192.217,
    ["Pt"]  = 195.084,
    ["Au"]  = 196.966569,
    ["Hg"]  = 200.592,
    ["Tl"]  = 204.38,
    ["Pb"]  = 207.2,
    ["Bi"]  = 208.98040,
    ["Po"]  = 209,
    ["At"]  = 210,
    ["Rn"]  = 222,
    ["Fr"]  = 223,
    ["Ra"]  = 226,
    ["Ac"]  = 227,
    ["Th"]  = 232.0377,
    ["Pa"]  = 231.03588,
    ["U"]   = 238.02891,
    ["Np"]  = 237,
    ["Pu"]  = 244,
    ["Am"]  = 243,
    ["Cm"]  = 247,
    ["Bk"]  = 247,
    ["Cf"]  = 251,
    ["Es"]  = 252,
    ["Fm"]  = 257,
    ["Uue"] = 315,
    ["Ubn"] = 299,
}

function evaluate(s)
    s = s .. '['
    local sum = 0.0
    local symbol = ""
    local number = ""

    for i=1,s:len() do
        local c = s:sub(i,i)
        if '@' <= c and c <= '[' then
            local n = 1
            if number ~= "" then
                n = tonumber(number)
            end
            if symbol ~= "" then
                sum = sum + atomicMass[symbol] * n
            end
            if c == '[' then
                break
            end
            symbol = tostring(c)
            number = ""
        elseif 'a' <= c and c <= 'z' then
            symbol = symbol .. c
        elseif '0' <= c and c <= '9' then
            number = number .. c
        else
            error("Unexpected symbol `"..c.."` in molecule")
        end
    end

    return sum
end

function replaceFirst(text, search, replacement)
    local pattern = search:gsub('%W', '%%%1')
    return string.gsub(text, pattern, replacement, 1)
end

function replaceParens(s)
    local letter = "s"
    while true do
        local start = string.find(s, "(", 1, true)
        if start == nil then
            break
        end

        for i=start,s:len() do
            local c = s:sub(i,i)
            if c == ')' then
                local expr = s:sub(start + 1, i - 1)
                local symbol = '@' .. letter
                local search = s:sub(start, i)
                s = replaceFirst(s, search, symbol)
                atomicMass[symbol] = evaluate(expr)
                letter = string.char(string.byte(letter) + 1)
                break
            end
            if c == '(' then
                start = i
            end
        end
    end
    return s
end

local molecules = {
    "H", "H2", "H2O", "H2O2", "(HO)2", "Na2SO4", "C6H12",
    "COOH(C(CH3)2)3CH3", "C6H4O2(OH)4", "C27H46O", "Uue"
}

for i,molecule in pairs(molecules) do
    local mass = evaluate(replaceParens(molecule))
    print(string.format("%17s -> %7.3f", molecule, mass))
end
