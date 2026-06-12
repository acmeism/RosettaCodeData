import htmlparser, httpclient, os, re, strutils, xmltree

let re1 = re("""<li><a href="/wiki/(.*?)"""")
const Page = "http://rosettacode.org/wiki/Category:Programming_Tasks"
var client = newHttpClient()

# Find tasks.
var body = client.getContent(Page)
var tasks: seq[string]
var start = 0
while true:
  var matches: array[1, string]
  start = body.find(re1, matches, start) + 1
  if start == 0: break
  if not matches[0].startsWith("Category:"):
    tasks.add matches[0]

const Base = "http://rosettacode.org/wiki/"
const Limit = 3   # number of tasks to print out.
let re2 = re("""(?s)using any language you may know.</div>(.*?)<mw:tocplace>""")
for i, task in tasks:
  var matches: array[2, string]
  let page = Base & task
  body = client.getContent(page)
  if body.find(re2, matches) < 0:
    raise newException(ValueError, "unable to find pattern in page.")
  let xmlnode = matches[0].parseHtml()  # Build an XML tree from the HTML.
  echo task.replace('_', ' ')
  echo xmlnode.innerText()              # Echo the tree as text.
  if i == Limit - 1: break
  os.sleep(5000)    # Wait 5 seconds before processing next task.
