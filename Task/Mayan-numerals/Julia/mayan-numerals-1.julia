using Gumbo

mayan_glyphs(x, y) = (x == 0 && y == 0) ? "\n<td>Θ</td>\n" : "<td>\n" * "●" ^ x * "<br />\n───" ^ y * "</td>\n"

inttomayan(n) = (s = string(n, base=20); map(ch -> reverse(divrem(parse(Int, ch, base=20), 5)), split(s, "")))

function testmayan()
    startstring = """\n
<style>
table.roundedcorners {
  border: 1px solid DarkOrange;
  border-radius: 13px;
  border-spacing: 1;
  }
table.roundedcorners td,
table.roundedcorners th {
  border: 2px solid DarkOrange;
  border-radius: 13px;
  border-bottom: 3px solid DarkOrange;
  vertical-align: bottom;
  text-align: center;
  padding: 10px;
  }
</style>
\n"""

    txt = startstring

    for n in [4005, 8017, 326205, 886205, 70913241, 2147483647]
    txt *= "<h3>The Mayan representation for the integer $n is: </h3><table class=\"roundedcorners\"><tr>" *
            join(map(x -> mayan_glyphs(x[1], x[2]), inttomayan(n))) * "</tr></table>\n\n"
    end

    println(parsehtml(txt))
end

testmayan()
