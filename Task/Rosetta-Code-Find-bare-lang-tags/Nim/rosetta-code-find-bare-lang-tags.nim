import algorithm, htmlparser, httpclient, json
import sequtils, strformat, strscans, tables, times, xmltree
import strutils except escape

const

  Rosorg = "http://rosettacode.org"
  QUri = "/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=json"
  QdUri = "/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Draft_Programming_Tasks&cmlimit=500&format=json"
  SqUri = "http://www.rosettacode.org/mw/index.php?title="


proc addPages(pages: var seq[string], fromJson: JsonNode) =
  for d in fromJson{"query", "categorymembers"}:
    pages.add SqUri & d["title"].getStr().replace(" ", "_").escape() & "&action=raw"


proc getPages(client: var HttpClient; uri: string): seq[string] =
  let response = client.get(Rosorg & uri)
  if response.status == $Http200:
    var fromJson = response.body.parseJson()
    result.addPages(fromJson)
    while fromJson.hasKey("continue"):
      let cmcont = fromJson{"continue", "cmcontinue"}.getStr()
      let cont = fromJson{"continue", "continue"}.getStr()
      let response = client.get(Rosorg & uri & fmt"&cmcontinue={cmcont}&continue={cont}")
      fromJson = response.body.parseJson()
      result.addPages(fromJson)

proc processTaskPages(client: var HttpClient; pages: seq[string]; verbose = false) =
  var totalCount = 0
  var langCount: CountTable[string]

  for page in pages:
    var count, checked = 0
    try:
      let response = client.get(page)
      if response.status == $Http200:
        let doc = response.body.parseHtml()
        if doc.kind != xnElement: continue
        var lastText = ""
        for elem in doc:
          if elem.kind == xnElement and elem.tag == "lang":
            if elem.attrs.isNil:
              inc count
              if lastText.len != 0:
                if verbose:
                  echo "Missing lang attribute for lang ", lastText
                langCount.inc lastText
            else:
              inc checked
          elif elem.kind == xnText:
            discard elem.text.scanf("=={{header|$+}}", lastText):
    except CatchableError:
      if verbose:
        echo &"Page {page} is not loaded or found: {getCurrentExceptionMsg()}"
      continue

    if count > 0 and verbose:
      echo &"Page {page} had {count} bare lang tags."
    inc totalCount, count

  echo &"Total bare tags: {totalCount}."
  for k in sorted(toSeq(langCount.keys)):
    echo &"Total bare <lang> for language {k}: ({langcount[k]})"


echo "Programming examples at ", now()
var client = newHttpClient()
client.processTaskPages(client.getPages(QUri))

echo "\nDraft programming tasks:"
client.processTaskPages(client.getPages(QdUri))
