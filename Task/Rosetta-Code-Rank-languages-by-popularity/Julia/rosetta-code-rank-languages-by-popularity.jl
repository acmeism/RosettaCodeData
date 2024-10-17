""" Rosetta code task rosettacode.org/wiki/Rosetta_Code/Rank_languages_by_popularity """

using Dates
using DataFrames
using HTTP
using JSON3

""" Get listing of all tasks and draft tasks with authors and dates created, with the counts as popularity """
function rosetta_code_language_example_counts(verbose = false)
    URL = "https://rosettacode.org/w/api.php?"
    LANGPARAMS = ["action" => "query", "format" => "json", "formatversion" => "2", "generator" => "categorymembers",
       "gcmtitle" => "Category:Programming_Languages", "gcmlimit" => "500", "rawcontinue" => "", "prop" => "title"]
    queryparams = copy(LANGPARAMS)
    df = empty!(DataFrame([[""], [0]], ["ProgrammingLanguage", "ExampleCount"]))

    while true  # get all the languages listed, with curid, eg rosettacode.org/w/index.php?curid=196 for C
        resp = HTTP.get(URL * join(map(p -> p[1] * (p[2] == "" ? "" : ("=" * p[2])), queryparams), "&"))
        json = JSON3.read(String(resp.body))
        pages = json.query.pages
        reg = r"The following \d+ pages are in this category, out of ([\d\,]+) total"
        for p in pages
            lang = replace(p.title, "Category:" => "")
            langpage = String(HTTP.get("https://rosettacode.org/w/index.php?curid=" * string(p.pageid)).body)
            if !((m = match(reg, langpage)) isa Nothing)
                push!(df, [lang, parse(Int, replace(m.captures[1], "," => ""))])
                verbose && println("Language: $lang, count: ", m.captures[1])
            end
        end
        !haskey(json, "query-continue") && break  # break if no more pages, else continue to next pages
        queryparams = vcat(LANGPARAMS, "gcmcontinue" => json["query-continue"]["categorymembers"]["gcmcontinue"])
    end

    return sort!(df, :ExampleCount, rev = true)
end

println("Top 20 Programming Languages on Rosetta Code by Number of Examples, As of: ", now())
println(rosetta_code_language_example_counts()[begin:begin+19, :])
