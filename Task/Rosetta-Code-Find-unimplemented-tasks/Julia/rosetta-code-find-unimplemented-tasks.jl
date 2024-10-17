using HTTP, JSON

const baseuri = "http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:"
const enduri = "&cmlimit=500&format=json"
queries(x) = baseuri * HTTP.Strings.escapehtml(x) * enduri

function getimplemented(query)
    tasksdone = Vector{String}()
    request = query
    while (resp = HTTP.request("GET", request)).status == 200
        fromjson = JSON.parse(String(resp.body))
        for d in fromjson["query"]["categorymembers"]
            if haskey(d, "title")
                push!(tasksdone, d["title"])
            end
        end
        if haskey(fromjson, "continue")
            cmcont, cont = fromjson["continue"]["cmcontinue"], fromjson["continue"]["continue"]
            request = query * "&cmcontinue=$cmcont&continue=$cont"
        else
            break
        end
    end
    tasksdone
end

alltasks = getimplemented(queries("Programming_Tasks"))

showunimp(x) = (println("\nUnimplemented in $x:"); for t in setdiff(alltasks,
    getimplemented(queries(x))) println(t) end)

showunimp("Julia")
showunimp("C++")
