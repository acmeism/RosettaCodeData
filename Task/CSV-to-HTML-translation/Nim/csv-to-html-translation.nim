import cgi, strutils

const csvtext = """Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!"""

proc row2tr(row): string =
  result = "<tr>"
  let cols = xmlEncode(row).split(",")
  for col in cols:
    result.add "<td>"&col&"</td>"
  result.add "</tr>"

proc csv2html(txt): string =
  result = "<table summary=\"csv2html program output\">\n"
  for row in txt.splitLines():
    result.add "  <tbody>"&row2tr(row)&"</tbody>\n"
  result.add "</table>"

echo csv2html(csvtext)
