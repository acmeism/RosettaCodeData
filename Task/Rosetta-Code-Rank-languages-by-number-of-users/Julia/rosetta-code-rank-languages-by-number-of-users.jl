""" Rank languages on Rosetta Code's site by number of users."""

using Dates
using HTTP
using JSON3

const URL = "https://rosettacode.org/w/api.php?"
const PARAMS = ["action" => "query", "format" => "json", "formatversion" => "2", "generator" => "categorymembers",
   "gcmtitle" => "Category:Language%20users", "gcmlimit" => "500", "rawcontinue" => "", "prop" => "categoryinfo"]

const resp = HTTP.get(URL * join(map(p -> p[1] * (p[2] == "" ? "" : ("=" * p[2])), PARAMS), "&"))
const counts = Pair{Int, String}[]

for p in JSON3.read(String(resp.body)).query.pages
    contains(p.title, "Category") && push!(counts, p.categoryinfo.size => p.title)
end

println("Date: ", now(), "\nLanguage       Users\n----------------------")
for p in sort!(filter(p -> p[1] >= 100, counts), rev = true)
    println(rpad(replace(p[2], r"Category:(.+) User" => s"\1"), 16), lpad(p[1], 4))
end
