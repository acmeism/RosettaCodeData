import std/[json, parseutils, sequtils, strformat, strutils]

type
  JsonPointer = string
  ParsingError = object of CatchableError
  ResolvingError = object of CatchableError

proc parseJsonPointer(p: JsonPointer): seq[string] =
  if p.len == 0: return
  if not p.startsWith('/'):
    raise newException(ParsingError, "pointers must start with a slash or be empty")
  for token in p[1..^1].split('/'):
    result.add token.multiReplace(("~1", "/"), ("~0", "~"))

proc getItem(data: JsonNode; token: string): JsonNode =
  if data.kind == JArray:
    var idx: int
    if parseInt(token, idx) > 0:
      if idx in 0..<data.len:
        result = data[idx]
  elif data.kind == JObject:
    result = data{token}

proc encode(tokens: seq[string]): string =
  if tokens.len == 0: return
  let encoded = tokens.mapIt(it.multiReplace(("~", "~0"), ("/", "~1")))
  result = '/' & encoded.join("/")

proc resolve(docMap: JsonNode; p: seq[string]): JsonNode =
  result = docMap
  for se, token in p:
    result = result.getItem(token)
    if result.isNil:
      raise newException(ResolvingError, &"\"{encode(p[0..se])}\" doesn't exist")

when isMainModule:

  const Doc = """
    {
      "wiki": {
        "links": [
          "https://rosettacode.org/wiki/Rosetta_Code",
          "https://discord.com/channels/1011262808001880065"
        ]
      },
      "": "Rosetta",
      " ": "Code",
      "g/h": "chrestomathy",
      "i~j": "site",
      "abc": ["is", "a"],
      "def": { "": "programming" }
    }"""

  let docMap = parseJson(Doc)

  const Tests = ["",
                 "/",
                 "/ ",
                 "/abc",
                 "/def/",
                 "/g~1h",
                 "/i~0j",
                 "/wiki/links/0",
                 "/wiki/links/1",
                 "/wiki/links/2",
                 "/wiki/name",
                 "/no/such/thing",
                 "bad/pointer"]

  for test in Tests:
    try:
      let data = parseJsonPointer(test)
      let res = docMap.resolve(data)
      echo &"\"{test}\" -> ", if docMap == res: Doc else: $res
    except ParsingError:
      echo &"Error: \"{test}\" {getCurrentExceptionMsg()}"
    except ResolvingError:
      echo &"Error: {getCurrentExceptionMsg()}"
    echo()
