using HTTP

function gettaskdescriptions(numtoprint = 3)
    page = "http://rosettacode.org/wiki/Category:Programming_Tasks"
    body = String(HTTP.get(page).body)
    tasks = [m.captures[1] for m in eachmatch(r"<li><a href=\"/wiki/([^\"]+)\"", body)]
    base = "http://rosettacode.org/wiki/"
    for (i, task) in enumerate(tasks)
        page = base * task
        body = String(HTTP.get(page).body)
        m = match(r"using any language you may know.</div>(.+)<div id=\"toc\""s, body)
        m != nothing && println(replace(m.captures[1], r"<[^>]*>"s => ""), "\n", "="^60, "\n")
        i >= numtoprint && break
        sleep(rand(3:7))   # wait 5 +/- 2 seconds before processing next task
    end
end

gettaskdescriptions()
