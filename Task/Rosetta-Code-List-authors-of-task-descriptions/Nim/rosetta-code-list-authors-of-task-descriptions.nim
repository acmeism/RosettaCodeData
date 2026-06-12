import algorithm, httpclient, re, strutils, tables

let
  re1 = re("""<li><a href="/wiki/(.*?)"""")
  re2 = re("""a href="/wiki/User:|mw/index\.php\?title=User:|wiki/Special:Contributions/([^"&]+)""")

const
  Url1 = "http://rosettacode.org/wiki/Category:Programming_Tasks"
  Url2 = "http://rosettacode.org/wiki/Category:Draft_Programming_Tasks"
  Urls = [Url1, Url2]

var client = newHttpClient()

var tasks: seq[string]
var matches: array[1, string]
var start = 0
for url in Urls:
  let body = client.getContent(url)
  # Find all tasks.
  while true:
    start = body.find(re1, matches, start) + 1
    if start == 0: break
    if not matches[0].startsWith("Category:"):
      tasks.add matches[0]

var authors: CountTable[string]
for task in tasks:
  # Check the last or only history page for each task.
  let page = "http://rosettacode.org/mw/index.php?title=$#&dir=prev&action=history".format(task)
  let body = client.getContent(page)
  # Find all the users in that page. The task author should be the final user on that page.
  var matches: array[1, string]
  start = 0
  while true:
    start = body.find(re2, matches, start) + 1
    if start == 0: break
  let author = matches[0].replace('-', ' ')
  # Add this task to the author's count.
  authors.inc(author)

# Sort the authors in descending order by number of tasks created.
authors.sort(Descending)

# Print the top twenty.
echo "Total tasks:   ", tasks.len
echo "Total authors: ", authors.len
echo "\nThe top 20 authors by number of tasks created are:\n"
echo "Pos  Tasks  Author"
echo "===  =====  ======"
var pos = 0
for author, count in authors.pairs:
  inc pos
  echo ($pos).align(2), "    ", ($count).align(3), "   ", author
  if pos == 20: break
