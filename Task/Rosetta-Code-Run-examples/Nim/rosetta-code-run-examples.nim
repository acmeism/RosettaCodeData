import htmlparser, httpclient, os, osproc, re, sets, strutils, xmltree

const
  Url1 = "http://rosettacode.org/wiki/Category:Programming_Tasks"
  Url2 = "http://rosettacode.org/wiki/Category:Draft_Programming_Tasks"
  Urls = [Url1, Url2]

proc getAllTasks(client: HttpClient): HashSet[string] =
  let regex = re("""<li><a href="/wiki/(.*?)"""")
  var matches: array[1, string]
  var start = 0
  for url in Urls:
    let body = client.getContent(url)
    # Find all tasks.
    while true:
      start = body.find(regex, matches, start) + 1
      if start == 0: break
      if not matches[0].startsWith("Category:"):
        result.incl matches[0]

let client = newHttpClient()
let tasks = client.getAllTasks()

while true:
  stdout.write "Enter the exact name of the task: "
  stdout.flushFile()
  let task = stdin.readLine().strip().replace(' ', '_')
  if task notin tasks:
    echo "Sorry a task with that name doesn't exist."
    continue

  let url = "https://rosettacode.org/w/index.php?title=" & task & "&action=edit"
  let body = client.getContent(url)
  var lang: string
  while true:
    stdout.write "Enter the language Go/Nim/Perl/Python : "
    stdout.flushFile()
    lang = stdin.readLine().strip().toLowerAscii
    if lang in ["go", "nim", "perl", "python"]:
      break
    echo "Sorry that language is not supported."

  var lang2, lang3, ext: string
  case lang
  of "go":
    lang2 = "Go"
    lang3 = """("go"|"Go"|"GO")"""
    ext = "go"
  of "nim":
    lang2 = "Nim"
    lang3 = """("nim"|"Nim")"""
    ext = "nim"
  of "perl":
    lang2 = "Perl"
    lang3 = """("perl"|"Perl")"""
    ext = "pl"
  of "python":
    lang2 = "Python"
    lang3 = """("python"|"Python")"""
    ext = "py"

  let fileName = "rc_temp." & ext
  let header = r"(?s)==\{\{header\|$#\}\}".format(lang2)
  let language = r"lt;syntaxhighlight lang=$#>".format(lang3)
  let regex = re(header & r"==.*?&" & language & r"(.*?)&lt;/syntaxhighlight>")
  var matches: array[2, string]
  let idx = body.find(regex, matches)
  if idx < 0:
    echo "No runnable task entry for that language was detected."
    continue

  let source = parseHtml(matches[1]).innerText()
  echo "\nThis is the source code for the first or only runnable program:\n"
  echo source
  stdout.write "\nDo you want to run it (y/n)? "
  stdout.flushFile()
  var answer = stdin.readLine()
  if answer in ["y", "Y"]:
    fileName.writeFile(source)
    let cmd = case lang
              of "go": "go run " & fileName
              of "nim": "nim r -d:release --threads:on -d:ssl " & fileName
              of "perl": "perl " & fileName
              of "python": "python " & fileName
              else: ""
    discard execCmd cmd
    removeFile fileName

  stdout.write "\nDo another one (y/n)? "
  stdout.flushFile()
  answer = stdin.readLine()
  if answer notin ["y", "Y"]:
    break
