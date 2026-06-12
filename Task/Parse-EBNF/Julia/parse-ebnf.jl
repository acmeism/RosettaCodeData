struct Grammar
    regex::Regex
    rules::Dict{Symbol,Regex}
    root::Regex
    function Grammar(regex::Regex)
        names = keys(match(regex, ""))
        new(regex,
            Dict{Symbol,Regex}(
                Symbol(name) => Regex(
                    "$(regex.pattern)(?&$(name))",
                    regex.compile_options,
                    regex.match_options
                )
                for name in names if name isa String),
            Regex(
                "$(regex.pattern)^\\s*(?&$(first(names)))\\s*\$",
                regex.compile_options,
                regex.match_options))
    end
end

Base.getindex(grammar::Grammar, key) = grammar.rules[key]
Base.occursin(grammar::Grammar, str::AbstractString) = occursin(grammar.root, str)
Base.show(io::IO, grammar::Grammar) = print(io, "Grammar(", grammar.regex, ")")

const ebnfgrammar = Grammar(r"""
(?(DEFINE) # EBNF syntax
(?<syntax>
    (?&title)? \s*+ { \s*+ ( (?&production) \s*+ )* } \s*+ (?&comment)? )
(?<production>
    (?&identifier) \s*+ = \s*+ (?&expression) \s*+ [.;] )
(?<expression>
    (?&term) ( \s*+ \| \s*+ (?&term) )* )
(?<term>
    (?&factor) ( \s*+ (?&factor) )* )
(?<factor>
    (?&identifier)
|   (?&literal)
|   \[ \s*+ (?&expression) \s*+ \]
|   \( \s*+ (?&expression) \s*+ \)
|    { \s*+ (?&expression) \s*+  } )
(?<identifier>
    [^'"\s=|(){}[\].;]+ )
(?<title>
    (?&literal) )
(?<comment>
    (?&literal) )
(?<literal>
    ' [^']+ '
|   " [^"]+ " )
)"""x)

function syntax(grammar::Grammar, str::AbstractString)
    if occursin(grammar[:syntax], str)
        """(?(DEFINE)$(join(production(grammar, eachmatch(grammar[:production], str)))))"""
    else
        throw(ErrorException("Invalid EBNF syntax."))
    end
end

production(grammar::Grammar, iter) = (production(grammar, m.match) for m in iter)
function production(grammar::Grammar, str::AbstractString)
    rstrip(c -> isspace(c) || c == '.' || c == ';', str)
    id, expr = split(str, r"\s*=\s*", limit=2)
    "(?<$(id)>" * join(
        expression(grammar, eachmatch(grammar[:expression], expr)),
        "\\s*+|\\s*+") * "\\s*+)"
end

expression(grammar::Grammar, iter) = (expression(grammar, m.match) for m in iter)
function expression(grammar::Grammar, str::AbstractString)
    join(term(grammar, eachmatch(grammar[:term], str)), "\\s*+|\\s*+")
end

term(grammar::Grammar, iter) = (term(grammar, m.match) for m in iter)
function term(grammar::Grammar, str::AbstractString)
    join(factor(grammar, eachmatch(grammar[:factor], str)), "\\s*+")
end

factor(grammar::Grammar, iter) = (factor(grammar, m.match) for m in iter)
function factor(grammar::Grammar, str::AbstractString)
    str = strip(str)
    if startswith(str, r"['\"]")
        literal(grammar, str)
    elseif startswith(str, r"[[({]")
        "(\\s*+" * expression(grammar, str[begin+1:end-1]) * (
            if startswith(str, '[')
                "\\s*+)?"
            elseif startswith(str, '{')
                "\\s*+)*"
            else
                "\\s*+)"
            end
        )
    else
        "(?&$(str))"
    end
end

literal(::Grammar, str::AbstractString) = "\\Q$(str[begin+1:end-1])\\E"

grammar(ebnf::AbstractString) = Grammar(Regex(syntax(ebnfgrammar, ebnf)))

using Test

oneliner = grammar("""
"a" {
    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
} "z"
""")

@testset "One liner" begin
    @test occursin(oneliner, "a1a3a4a4a5a6")
    @test occursin(oneliner, "a1 a2a6")
    @test occursin(oneliner, "a1 a3 a4 a6")
    @test !occursin(oneliner, "a1 a4 a5 a6")
    @test !occursin(oneliner, "a1 a2 a4 a5 a5 a6")
    @test !occursin(oneliner, "a1 a2 a4 a5 a6 a7")
    @test !occursin(oneliner, "your ad here")
end

arithmetic = grammar("""
{
    expr = term { plus term } .
    term = factor { times factor } .
    factor = number | '(' expr ')' .

    plus = "+" | "-" .
    times = "*" | "/" .

    number = digit { digit } .
    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
}
""")

@testset "Arithmetic expressions" begin
    @test occursin(arithmetic, "2")
    @test occursin(arithmetic, "2*3 + 4/23 - 7")
    @test occursin(arithmetic, "(3 + 4) * 6-2+(4*(4))")
    @test !occursin(arithmetic, "-2")
    @test !occursin(arithmetic, "3 +")
    @test !occursin(arithmetic, "(4 + 3")
end

@testset "Invalid EBNF" begin
    @test_throws ErrorException grammar("""a = "1";""")
    @test_throws ErrorException grammar("""{ a = "1";""")
    @test_throws ErrorException grammar("""{ hello world = "1"; }""")
    @test_throws ErrorException grammar("{ foo = bar . }")
end

