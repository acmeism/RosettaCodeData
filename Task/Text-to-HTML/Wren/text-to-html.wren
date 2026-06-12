import "./pattern" for Pattern

var t = """     Sample Text

This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.

* This is a bulleted list with a less than sign (<)

* And this is its second line with a greater than sign (>)

A 'normal' paragraph between the lists.

1. This is a numbered list with an ampersand (&)

2. "Second line" in double quotes

3. 'Third line' in single quotes

That's all folks."""

// prefer the standard &quot; for escaping a double-quote character rather than Go's &#34;
var escapes = [ ["&", "&amp;"], ["<", "&lt;"], [">", "&gt;"], ["\"", "&quot;"], ["'", "&#39;"] ]
for (esc in escapes) t = t.replace(esc[0], esc[1])
var paras = t.split("\n\n")
var ol = Pattern.new("/d.", Pattern.start)

// Assume if first character of first paragraph is white-space
// then it's probably a document title.
var firstChar = paras[0][0]
var title = "Untitled"
var k = 0
if (firstChar == " " || firstChar == "\t") {
    title = paras[0].trim()
    k = 1
}
System.print("<html>")
System.print("<head><title>%(title)</title></head>")
System.print("<body>")

var blist = false
var nlist = false
for (para in paras.skip(k)) {
    var para2 = para.trim()
    var cont = false
    if (para2.startsWith("*")) {
        if (!blist) {
            blist = true
            System.print("<ul>")
        }
        para2 = para2[1..-1].trim()
        System.print("  <li>%(para2)</li>")
        cont = true
    } else if (blist) {
        blist = false
        System.print("</ul>")
    }

    if (!cont) {
        if (ol.isMatch(para2)) {
            if (!nlist) {
                nlist = true
                System.print("<ol>")
            }
            para2 = para2[2..-1].trim()
            System.print("  <li>%(para2)</li>")
            cont = true
        } else if (nlist) {
            nlist = false
            System.print("</ol>")
        }
        if (!cont && !blist && !nlist) System.print("<p>%(para2)</p>")
    }
}

if (blist) System.print("</ul>")
if (nlist) System.prin("</ol>")
System.print("</body>")
System.print("</html>")
