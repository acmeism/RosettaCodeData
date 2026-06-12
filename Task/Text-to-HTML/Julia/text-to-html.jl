using HttpCommon, Printf

const exampletxt = """            Sample Text

This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.

* This is a bulleted list with a less than sign (<)

* And this is its second line with a greater than sign (>)

A 'normal' paragraph between the lists.

1. This is a numbered list with an ampersand (&)

2. "Second line" in double quotes

3. 'Third line' in single quotes

That's all folks."""

function txt_to_html(t = exampletxt)
    p = r"\n\s*(\n\s*)+"
    ul = r"^\*"
    ol = r"^\d\."
    paras = map(p -> escapeHTML(string(p)), split(t, r"[\r\n]+"))
    # Assume if first character of first paragraph is white-space
    # then it's probably a document title.
    firstchar = first(first(paras))
    title = "Untitled"
    k = 1
    if firstchar == ' ' || firstchar == '\t'
        title = strip(paras[1])
        k = 2
    end
    println("<html>")
    @printf("<head><title>%s</title></head>\n", title)
    println("<body>")

    blist, nlist = false, false
    for para in @view paras[k:end]
        para2 = strip(para)

        if occursin(ul, para2)
            if !blist
                blist = true
                println("<ul>")
            end
            para2 = strip(para2[2:end])
            @printf("  <li>%s</li>\n", para2)
            continue
        elseif blist
            blist = false
            println("</ul>")
        end

        if occursin(ol, para2)
            if !nlist
                nlist = true
                println("<ol>")
            end
            para2 = strip(para2[3:end])
            @printf("  <li>%s</li>\n", para2)
            continue
        elseif nlist
            nlist = false
            println("</ol>")
        end

        if !blist && !nlist
            @printf("<p>%s</p>\n", para2)
        end
    end
    if blist
        println("</ul>")
    end
    if nlist
        println("</ol>")
    end
    println("</body>")
    println("</html>")
end

txt_to_html()
