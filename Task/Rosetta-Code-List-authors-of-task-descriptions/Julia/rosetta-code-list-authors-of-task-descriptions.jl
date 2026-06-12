""" Rosetta code task rosettacode.org/wiki/Rosetta_Code/List_authors_of_task_descriptions """

using Dates
using DataFrames
using EzXML
using HTTP
using JSON3

""" Get Rosetta Code authors of tasks, output as dataframe """
function rosetta_code_authors(verbose = false)
    URL = "https://rosettacode.org/w/api.php?"
    PARAMS = ["action" => "query", "format" => "json", "formatversion" => "2", "generator" => "categorymembers",
       "gcmtitle" => "Category:Programming_Tasks", "gcmlimit" => "500", "rawcontinue" => "", "prop" => "title"]
    DRAFTPARAMS = ["action" => "query", "format" => "json", "formatversion" => "2", "generator" => "categorymembers",
       "gcmtitle" => "Category:Draft_Programming_Tasks", "gcmlimit" => "500", "rawcontinue" => "", "prop" => "title"]

    titles = Pair{String, Bool}[]
    dateformat = DateFormat("HH:SS, d U y")
    df = empty!(DataFrame([[""], [""], [now()], [true]], ["Author", "Title", "CreationDate", "IsDraftTask"]))

    for param in [PARAMS, DRAFTPARAMS] # get the titles of the tasks and draft tasks, store list in alltasks
        continueposition = ""
        queryparams = copy(param)
        isdraft = param == DRAFTPARAMS
        while true
            resp = HTTP.get(URL * join(map(p -> p[1] * (p[2] == "" ? "" : ("=" * p[2])), queryparams), "&"))
            json = JSON3.read(String(resp.body))
            pages = json.query.pages
            for p in pages
                push!(titles,  p.title => isdraft)
            end
            !haskey(json, "query-continue") && break  # break if no more pages, else continue to next pages
            queryparams = vcat(param, "gcmcontinue" => json["query-continue"]["categorymembers"]["gcmcontinue"])
        end
    end


    for (i, title) in pairs(titles) # Get author of first revision of each page, assumed to be task creator/author
        resp = HTTP.get("https://rosettacode.org/w/index.php?title=" * escape(title[1]) * "&dir=prev&action=history")
        html = root(parsehtml(String(resp.body)))
        xpath = "//span[@class=\"history-user\"]/a"
        header = findlast(xpath, html)
        author = header != nothing ? nodecontent(header) : ""
        xpath2 = "//a[@class=\"mw-changeslist-date\"]"
        header2 = findlast(xpath2, html)
        creationdate = header2 != nothing ? DateTime(nodecontent(header2), dateformat) : missing
        if author != ""
            author = replace(author, r".+>" => "")  # clean up from the hosting change
            push!(df, [author, title[1], creationdate, title[2]])
            verbose && println("Processed author $author of $title created $creationdate: page $i of ", length(titles))
        end
    end
    sort!(df, :CreationDate, rev = true)
    authorfreqs = sort!(combine(groupby(df, :Author), nrow => :Freq), :Freq, rev = true)
    return df, authorfreqs
end

rosetta_code_authors()
