import algorithm, httpclient, json, strformat, strscans, strutils

const
  Action = "action=query"
  Format = "format=json"
  FormatVersion = "formatversion=2"
  Generator = "generator=categorymembers"
  GcmTitle = "gcmtitle=Category:Language%20users"
  GcmLimit = "gcmlimit=500"
  Prop = "prop=categoryinfo"

  Page = "http://rosettacode.org/w/api.php?"  &
         [Action, Format, Formatversion, Generator, GcmTitle, GcmLimit, Prop].join("&")

type Counts = tuple[lang: string, count: int]

proc cmp(a, b: Counts): int =
  ## Compare two count tuples. Place the one with greater count field first and when
  ## count fields are equal, place the one with the first name in alphabetic order.
  result = cmp(b.count, a.count)
  if result == 0: result = cmp(a.lang, b.lang)

var client = newHttpClient()
var counts: seq[Counts]
var url = Page

while true:

  # Access to the page and load the JSON representation.
  let response = client.get(url)
  if response.status != $Http200: break
  let root = response.body.parseJson()

  # Extract language names and number of users.
  for node in root{"query", "pages"}:
    var lang: string
    if node["title"].getStr().scanf("Category:$+ User", lang):
      let count = node{"categoryinfo", "size"}.getInt()
      counts.add (lang, count)
  if "continue" notin root: break

  # Load continuation page.
  let gcmcont = root{"continue", "gcmcontinue"}.getStr()
  let cont = root{"continue", "continue"}.getStr()
  url = Page & fmt"&gcmcontinue={gcmcont}&continue={cont}"

# Sort and display.
counts.sort(cmp)
var rank, lastCount = 0
for i, (lang, count) in counts:
  if count != lastCount:
    rank = i + 1
    lastCount = count
  echo &"{rank:3} {count:4} - {lang}"
