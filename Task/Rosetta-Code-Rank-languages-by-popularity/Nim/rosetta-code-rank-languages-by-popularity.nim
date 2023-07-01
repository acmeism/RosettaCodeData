import std/[Algorithm, httpclient, json, re, strformat, strutils]

const
  LangSite = "http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Languages&cmlimit=500&format=json"
  CatSite = "http://www.rosettacode.org/w/index.php?title=Special:Categories&limit=5000"
let regex = re"title=""Category:(.*?)"">.+?</a>.*\((.*) members\)"

type Rank = tuple[lang: string, count: int]

proc cmp(a, b: Rank): int =
  result = cmp(b.count, a.count)
  if result == 0: result = cmp(a.lang, b.lang)

proc add(langs: var seq[string]; fromJson: JsonNode) =
  for entry in fromJson{"query", "categorymembers"}:
    let title = entry["title"].getStr()
    if title.startsWith("Category:"):
      langs.add title[9..^1]

var client = newHttpClient()
var langs: seq[string]
var url = LangSite
while true:
  let response = client.get(url)
  if response.status != $Http200: break
  let fromJson = response.body.parseJson()
  langs.add fromJson
  if "continue" notin fromJson: break
  let cmcont = fromJson{"continue", "cmcontinue"}.getStr
  let cont = fromJson{"continue", "continue"}.getStr
  url = LangSite & fmt"&cmcontinue={cmcont}&continue={cont}"

var ranks: seq[Rank]
for line in client.getContent(CatSite).findAll(regex):
  let lang = line.replacef(regex, "$1")
  if lang in langs:
    let count = parseInt(line.replacef(regex, "$2").replace(",", "").strip())
    ranks.add (lang, count)

ranks.sort(cmp)
for i, rank in ranks:
  echo &"{i + 1:3} {rank.count:4} - {rank.lang}"
