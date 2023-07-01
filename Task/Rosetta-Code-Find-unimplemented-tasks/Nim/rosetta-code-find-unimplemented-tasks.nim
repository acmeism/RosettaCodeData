import httpclient, strutils, xmltree, xmlparser, cgi, os


proc findrc(category: string): seq[string] =

  var
    name = "http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:$#&cmlimit=500&format=xml" % encodeUrl(category)
    cmcontinue = ""
    client = newHttpClient()

  while true:
    var x = client.getContent(name & cmcontinue).parseXml()
    for node in x.findAll("cm"):
      result.add node.attr("title")

    cmcontinue.setLen(0)
    for node in x.findAll("continue"):
      let u = node.attr("cmcontinue")
      if u.len != 0: cmcontinue = u.encodeUrl()

    if cmcontinue.len > 0: cmcontinue = "&cmcontinue=" & cmcontinue
    else: break


proc chooselang(): string =
  if paramCount() < 1: "Nim" else: paramStr(1)


let alltasks = findrc("Programming_Tasks")
let lang = chooselang()
let langTasks = lang.findrc()
echo "Unimplemented tasks for language ", lang, ':'
for task in alltasks:
  if task notin langTasks:
    echo "  ", task
