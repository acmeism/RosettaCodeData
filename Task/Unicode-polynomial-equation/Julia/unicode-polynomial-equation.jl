import Base.print

struct LaurentPolynomial{T}
    powtocoef::Dict{Int,T}
    varname::Char
end

function tosuper(i)
    s = ""
    if i != 1
        if i < 0
            s = "\u207b"
            i = -i
        end
        s *= prod([reverseudi[x] for x in reverse(digits(i))])
    end
    return s
end

function print(io::IO, lp::LaurentPolynomial)
    if isempty(lp.powtocoef) || all(iszero, values(lp.powtocoef))
        print("0")
        return
    end
    firstterm = true
    dorev = minimum(keys(lp.powtocoef)) >= 0
    for p in sort!(collect(lp.powtocoef), lt =(a,b)->a[1]<b[1], rev=dorev)
        e, c = p[1], p[2]
        if c != 0
            if !firstterm
                print(c < 0 ? " - " : " + ")
                c = abs(c)
            end
            sfrac = get(tofracs, c - trunc(c), "")
            sint = string(Int(trunc(c)))
            s = round(c) == c ? sint : sfrac == "" ? string(c) :
                sint == "0" ? sfrac : sint * sfrac
            print(c == 1 && e != 0 ? "" : s)
            e != 0 && print(lp.varname, tosuper(e))
            firstterm = false
        end
    end
end

const uniexp = [['\u2070', '\u00b9', '\u00b2', '\u00b3']; collect('\u2074':'\u2079')]
const allsuper = String(vcat(uniexp, ['\u207a', '\u207b']))
const udi = Dict([u => i-1 for (i, u) in enumerate(uniexp)])
const reverseudi = Dict([v => k for (k, v) in udi])
const uch = Dict(['\u207a' => '+', '\u207b' => '-', '\u00b7' => ' ',
    '\u00d7' => ' ', '\u2091' => '^', '\u23e8' => 'E'])
const fracs = Dict(['¼' => "$(1/4)", '½' => "$(1/2)", '¾' => "$(3/4)", '⅐' => "$(1/7)",
    '⅑' => "$(1/9)", '⅒' => "$(1/10)", '⅓' => "$(1/3)", '⅔' => "$(2/3)", '⅕' => "$(1/5)",
    '⅖' => "$(2/5)", '⅗' => "$(3/5)", '⅘' => "$(4/5)", '⅙' => "(1/6)", '⅚' => "$(5/6)",
    '⅛' => "$(1/8)", '⅜' => "$(3/8)", '⅝' => "$(5/8)", '⅞' => "$(7/8)", '↉' => "$(0/3)"])
const tofracs = Dict(0.25 => '¼', 0.5 => '½', 0.75 => '¾', 0.2 => '⅕')
allfrac = join(vcat(collect(keys(fracs))), "|")

utoascii(c) = (x = haskey(udi, c) ? Char('0' + udi[c]) : haskey(uch, c) ? uch[c] : c)

function fcoef(termstring, varname)
    m = match(r"(\d+)⁄(\d+)", termstring).captures
    return "$(parse(Float64, m[1])/parse(Float64, m[2]))$varname^0"
end

function xcoef(termstring, varname)
    m = match(Regex("(\\d+)$varname([^⁄\\+]*)⁄(\\d+)"), termstring).captures
    coe = parse(Float64, m[1])/parse(Float64, m[3])
    return "$(coe)$varname$(m[2])"
end

function fromvfrac(termstring)
    m = match(r"(\d*)(\D+)", termstring).captures
    s = string((m[1] == "" ? 0 : parse(Float64, m[1])) + parse(Float64, fracs[m[2][1]]))
end

function normalizeexpression(s, varname='x')
    s = replace(s, Regex("\\d*(" * allfrac * ")") => (x) -> fromvfrac(x))
    s = replace(replace(s, r"[^\+].+" => (x) -> "+$x"), r".+[^\+]$" => (x) -> "$x+")
    s = replace(replace(replace(s, r"\s+" => ""), r"\*\*|↑" => "^"), "\u23e8" => "e")
    s = replace(s, Regex(varname * "(?=[$allsuper]+)") => "$varname^")
    s = replace(prod([utoascii(c) for c in s]), r"\s+" => "")
    s = replace(s, r"[\-\+]+" => (x) -> isodd(count(y -> y == '-', x)) ? "+-" : "+")
    s = replace(replace(s, r"\^\+\-" => "^-"), r"\^\+" => "^")
    s = replace(s, Regex("(?<=[\\-\\+])$varname") => "1$varname")
    s = replace(s, r"(\d+)x([^⁄\+]*)⁄(\d+)" => (x) -> xcoef(x, varname))
    s = replace(s, r"(?<=[0-9])(,)(?=[0-9])" => "")
    s = replace(s, r"\d+⁄\d+" => (x) -> fcoef(x, varname))
    s = replace(s, r"\+([\d\.]+)\+" => SubstitutionString("+\\1$varname^0+"))
    return replace(s, Regex("(⁄|/)(" * varname * ")\\^?") =>
        (x) -> varname * (x[end] == '^' ? "^-" : "^-1"))
end

function topoly(s::String, varname='x')
    allcoef = Dict{Int,Float64}(0 => 0.0)
    s = normalizeexpression(s, varname)
    reg = Regex("[\\.\\-\\+\\deE\\/]*" * varname * "(?:\\^[\\d\\-]+)?(?=(?:[^\\+\\-]?(?:\\+|\\-)))")
    matched = collect(eachmatch(reg, s))
    pairs = [split(x.match, varname * "^") for x in matched]
    for p in pairs
        p[1] = replace(p[1], "+-" => "-")
        if length(p) == 1
            push!(p, "1")
            p[1] = replace(p[1], Regex(varname * "\$") => "")
        end
        coef, expo = tryparse(Float64, p[1]), tryparse(Int, p[2])
        coef = coef == nothing ? 1.0 : coef
        expo = expo == nothing ? 1 : expo
        if haskey(allcoef, expo)
            coef += allcoef[expo]
        end
        allcoef[expo] = coef
    end
    return LaurentPolynomial(allcoef, varname)
end

testcases = [
"1x⁵ - 2x⁴ + 42x³ + 0x² + 40x + 1",
"0e+0x⁰⁰⁷ + 00e-00x + 0x + .0x⁰⁵ - 0.x⁴ + 0×x³ + 0x⁻⁰ + 0/x + 0/x³ + 0x⁻⁵",
"1x⁵ - 2x⁴ + 42x³ + 40x + 1x⁰",
"+x⁺⁵ + -2x⁻⁻⁴ + 42x⁺⁺³ + +40x - -1",
"x^5 - 2x**4 + 42x^3 + 40x + 1",
"x↑5 - 2.00·x⁴ + 42.00·x³ + 40.00·x + 1",
"x⁻⁵ - 2⁄x⁴ + 42x⁻³ + 40/x + 1x⁻⁰",
"x⁵ - 2x⁴ + 42.000 000x³ + 40x + 1",
"x⁵ - 2x⁴ + 0,042x³ + 40.000,000x + 1",
"0x⁷ + 10x + 10x + x⁵ - 2x⁴ + 42x³ + 20x + 1",
"1E0x⁵ - 2,000,000.e-6x⁴ + 4.2⏨1x³ + .40e+2x + 1",
"x⁵ - x⁴⁄2 + 405x³⁄4 + 403x⁄4 + 5⁄2",
"x⁵ - ½x⁴ + 101¼x³ + 100¾x + 2½",
]

for s in testcases
    println(lpad(s, 48), "  =>  ", topoly(s, 'x'))
end
