import httpclient, os, re, strformat, strutils, sugar, times

const Template = "'http://tclers.tk/conferences/tcl/'yyyy-MM-dd'.tcl'"

proc get(url: string): string =
  var client = newHttpClient()
  result = client.getContent(url)
  if result.match(re"<!Doctype HTML[\s\S]*<Title>URL Not Found</Title>"):
    result = ""
  client.close()

let today = now()
const Back = 10
if paramCount() != 1:
  quit "Wrong number of parameters", QuitFailure
let needle = paramStr(1)
for i in -Back..1:
  let day = today + initTimeInterval(days = i)
  let url = day.format(Template)
  let haystack = url.get()
  if haystack.len != 0:
    let mentions = collect(newSeq):
                     for line in haystack.splitLines(keepEol = true):
                       if needle in line:
                         line
    if mentions.len > 0:
      echo &"{url}\n------\n{mentions.join()}------\n"
