using HTTP, JSON, Dates

rosorg = "http://rosettacode.org"
qURI = "/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=json"
qdURI = "/w/api.php?action=query&list=categorymembers&cmtitle=Category:Draft_Programming_Tasks&cmlimit=500&format=json"
sqURI = rosorg * "/wiki/"
topages(js, v) = for d in js["query"]["categorymembers"] push!(v, sqURI * replace(d["title"], " " => "_")) end

function getpages(uri)
    wikipages = Vector{String}()
    response = HTTP.request("GET", rosorg * uri)
    if response.status == 200
        fromjson = JSON.parse(String(response.body))
        topages(fromjson, wikipages)
        while haskey(fromjson, "continue")
            cmcont, cont = fromjson["continue"]["cmcontinue"], fromjson["continue"]["continue"]
            response = HTTP.request("GET", rosorg * uri * "&cmcontinue=$cmcont&continue=$cont")
            fromjson = JSON.parse(String(response.body))
            topages(fromjson, wikipages)
        end
    end
    wikipages
end

function processtaskpages(wpages, verbose=false)
    totalexamples = 0
    for pag in wpages
        response = HTTP.request("GET", pag)
        if response.status == 200
            n = length(collect(eachmatch(r"span class=\"mw-headline\"", String(response.body))))
            if verbose
                println("Wiki page $pag => $n examples.")
            end
            totalexamples += n
        end
    end
    println("Total of $totalexamples on $(length(wpages)) task pages.\n")
end


println("Programming examples at $(DateTime(now())):")
qURI |> getpages |> processtaskpages

println("Draft programming tasks:")
qdURI |> getpages |> processtaskpages
