import re, strutils, xmltree

const Text = """     Sample Text

This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.

* This is a bulleted list with a less than sign (<)

* And this is its second line with a greater than sign (>)

A 'normal' paragraph between the lists.

1. This is a numbered list with an ampersand (&)

2. "Second line" in double quotes

3. 'Third line' in single quotes

That's all folks."""


let p = re"\n\s*(\n\s*)+"
let ul = re"^\*"
let ol = re"^\d\."
let text = xmltree.escape(Text)
let paras = text.split(p)

# Assume if first character of first paragraph is white-space
# then it's probably a document title.
let firstChar = paras[0][0]
var titleString = "untitled"
var start = 0
if firstChar.isSpaceAscii:
  titleString = paras[0].strip()
  start = 1
echo "<html>"
echo "<head><title>", titleString, "</title></body>"
echo "<body>"

var blist, nlist = false
for ipara in start..paras.high:
  var para = paras[ipara].strip()

  if para.find(ul) >= 0:
    if not blist:
      blist = true
      echo "<ul>"
    echo "  <li>", para[1..^1].strip(), "</li>"
    continue
  elif blist:
    blist = false
    echo "</ul>"

  if para.find(ol) >= 0:
    if not nlist:
      nlist = true
      echo "<ol>"
    echo "  <li>", para[2..^1].strip(), "</li>"
    continue
  elif nlist:
    nlist = false
    echo "</ol>"

  if not (blist or nlist):
    echo "<p>", para, "</p>"

if blist: echo "</ul>"
if nlist: echo "</ol>"

echo "</body>"
echo "</html>"
