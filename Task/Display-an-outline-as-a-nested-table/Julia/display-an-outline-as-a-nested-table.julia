using DataFrames

text = """
Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.
"""

const bcolor = ["background: #ffffaa;", "background: #ffdddd;",
    "background: #ddffdd;", "background: #ddddff;"]
colorstring(n) = bcolor[n == 1 ? 1  : mod1(n - 1, length(bcolor) - 1) + 1]

function processtable(txt)
    df = DataFrame()
    indents = Int[]
    linetext = String[]
    for line in split(txt, "\n")
        if length(line) > 0
            n = findfirst(!isspace, line)
            push!(linetext, String(line[n:end]))
            push!(indents, n - 1)
        end
    end
    len = length(indents)
    divisor = gcd(indents)
    indents .= div.(indents, divisor)
    parent(i) = (n = findlast(x -> indents[x] < indents[i], 1:i-1)) == nothing ? 0 : n
    children(i) = findall(x -> parent(x) == i, 1:len)
    treesize(i) = (s = children(i); isempty(s) ? 1 : sum(treesize, s))
    prioronlevel(i) = (j = indents[i]; filter(x -> indents[x] == j, 1:i-1))
    treesizeprior(i) = (s = prioronlevel(i); isempty(s) ? 0 : sum(treesize, s))
    startpos(i) = (n = parent(i)) == 0 ? 0 : treesizeprior(n) - treesizeprior(i)
    function leveloneparent(i)
        p = parent(i)
        return p < 1 ? 1 : p ==1 ? sum(x -> indents[x] <= 1, 1:i) : leveloneparent(p)
    end
    df.TEXT = linetext
    df.INDENT = indents
    df.COLSPAN = [treesize(i) for i in 1:len]
    df.PRESPAN = [max(0, startpos(i)) for i in 1:len]
    df.LEVELONEPARENT = [leveloneparent(i) for i in 1:len]
    return df
end

function htmlfromdataframe(df)
    println("<h4>A Rosetta Code Nested Table</h4><table style=\"width:100%\" class=\"wikitable\" >")
    for ind in minimum(df.INDENT):maximum(df.INDENT)
        println("<tr>")
        for row in eachrow(df)
            if row[:INDENT] == ind
                if row[:PRESPAN] > 0
                    println("<td colspan=\"$(row[:PRESPAN])\"> </td>")
                end
                print("<td ")
                if row[:COLSPAN] > 0
                    println("colspan=\"$(row[:COLSPAN])\"")
                end
                println(" style = \"$(colorstring(row[:LEVELONEPARENT]))\" >$(row[:TEXT])</td>")
            end
        end
        println("</tr>")
    end
    println("</table>")
end

htmlfromdataframe(processtable(text))
textplus = text * "    Optionally add color to the nodes."
htmlfromdataframe(processtable(textplus))
