using Gumbo, AbstractTrees, HTTP, JSON, Dates

rosorg = "http://rosettacode.org"
qURI = "/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=json"
qdURI = "/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Draft_Programming_Tasks&cmlimit=500&format=json"
sqURI = "http://www.rosettacode.org/mw/index.php?title="

function topages(js, v)
    for d in js["query"]["categorymembers"]
        push!(v, sqURI * HTTP.Strings.escapehtml(replace(d["title"], " " => "_")) * "&action=raw")
    end
end

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
    totalcount = 0
    langcount = Dict{String, Int}()
    for pag in wpages
        count = 0
        checked = 0
        try
            response = HTTP.request("GET", pag)
            if response.status == 200
                doc = parsehtml(String(response.body))
                lasttext = ""
                for elem in StatelessBFS(doc.root)
                    if typeof(elem) != HTMLText
                        if tag(elem) == :lang
                            if isempty(attrs(elem))
                                count += 1
                                if lasttext != ""
                                    if verbose
                                        println("Missing lang attibute for lang $lasttext")
                                    end
                                    if !haskey(langcount, lasttext)
                                        langcount[lasttext] = 1
                                    else
                                        langcount[lasttext] += 1
                                    end
                                end
                            else
                                checked += 1
                            end
                        end
                    else
                        m = match(r"header\|(.+)}}==", text(elem))
                        lasttext = (m == nothing) ? "" : m.captures[1]
                    end
                end
            end
        catch y
            if verbose
                println("Page $pag is not loaded or found: $y.")
            end
            continue
        end
        if count > 0 && verbose
            println("Page $pag had $count bare lang tags.")
        end
        totalcount += count
    end
    println("Total bare tags: $totalcount.")
    for k in sort(collect(keys(langcount)))
        println("Total bare <lang> for language $k: $(langcount[k])")
    end
end

println("Programming examples at $(DateTime(now())):")
qURI |> getpages |> processtaskpages

println("\nDraft programming tasks:")
qdURI |> getpages |> processtaskpages
