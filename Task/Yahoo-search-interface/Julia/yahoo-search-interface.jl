""" Rosetta Code Yahoo search task. https://rosettacode.org/wiki/Yahoo!_search_interface """

using EzXML
using HTTP
using Logging

const pagesize = 7
const URI = "https://search.yahoo.com/search?fr=opensearch&pz=$pagesize&"

struct SearchResults
    title::String
    content::String
    url::String
end

mutable struct YahooSearch
    search::String
    yahoourl::String
    currentpage::Int
    usedpages::Vector{Int}
    results::Vector{SearchResults}
end
YahooSearch(s, url = URI) = YahooSearch(s, url, 1, Int[], SearchResults[])

function NextPage(yah::YahooSearch, link, pagenum)
    oldpage = yah.currentpage
    yah.currentpage = pagenum
    search(yah)
    yah.currentpage = oldpage
end

function search(yah::YahooSearch)
    push!(yah.usedpages, yah.currentpage)
    queryurl = yah.yahoourl * "b=$(yah.currentpage)&p=" * HTTP.escapeuri(yah.search)
    req = HTTP.request("GET", queryurl)
    # Yahoo's HTML is nonstandard, so send excess warnings from the parser to NullLogger
    html = with_logger(NullLogger()) do
        parsehtml(String(req.body))
    end
    for div in findall("//li/div", html)
        if haskey(div, "class")
            if startswith(div["class"], "dd algo") &&
               (a = findfirst("div/h3/a", div)) != nothing &&
               haskey(a, "href")
                url, title, content = a["href"], nodecontent(a), "None"
                for span in findall("div/p/span", div)
                    if haskey(span, "class") && occursin("fc-falcon", span["class"])
                        content = nodecontent(span)
                    end
                end
                push!(yah.results, SearchResults(title, content, url))
            elseif startswith(div["class"], "dd pagination")
                for a in findall("div/div/a", div)
                    if haskey(a, "href")
                        lnk, n = a["href"], tryparse(Int, nodecontent(a))
                        !isnothing(n) && !(n in yah.usedpages) && NextPage(yah, lnk, n)
                    end
                end
            end
        end
    end
end

ysearch = YahooSearch("RosettaCode")
search(ysearch)
println("Searching Yahoo for `RosettaCode`:")
println(
    "Found ",
    length(ysearch.results),
    " entries on ",
    length(ysearch.usedpages),
    " pages.\n",
)
for res in ysearch.results
    println("Title: ", res.title)
    println("Content: ", res.content)
    println("URL:     ", res.url, "\n")
end
