import "./json" for JSON
import "./iterate" for Indexed

var parseJSONPointer = Fn.new { |pointer|
    var tokens = []
    if (pointer == "") return [tokens, null]
    if (!pointer.startsWith("/")) {
        return [tokens, "pointers must start with a slash or be empty"]
    }
    for (token in pointer[1..-1].split("/")) {
        tokens.add(token.replace("~1", "/").replace("~0", "~"))
    }
    return [tokens, null]
}

var getItem = Fn.new { |data, token|
    if (data is List) {
        var idx = Num.fromString(token)
        if (idx && idx.isInteger && idx >= 0 && idx < data.count) {
            return [data[idx], true]
        }
    } else if (data is Map) {
        if (data.containsKey(token)) return [data[token], true]
    }
    return [null, false]
}

var encode = Fn.new { |tokens|
    var encoded = tokens.map { |t| t.replace("~", "~0").replace("/", "~1") }
    if (encoded.isEmpty) return ""
    return "/" + encoded.join("/")
}

var resolve = Fn.new { |docMap, p|
    var obj = docMap
    for (se in Indexed.new(p)) {
        var token = se.value
        var item = getItem.call(obj, token)
        if (!item[1]) {
            return [null, "\"%(encode.call(p[0..se.index]))\" does not exist"]
        }
        obj = item[0]
    }
    return [obj, null]
}

var doc = """
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
}
"""

var docMap = JSON.parse(doc)

var tests = [
    "",
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
    "bad/pointer"
]

for (test in tests) {
    var data = parseJSONPointer.call(test)
    test = "\"" + test + "\""
    if (data[1]) {
        System.print("error: %(test) %(data[1])")
    } else {
        var res = resolve.call(docMap, data[0])
        if (res[1]) {
            System.print("error: %(res[1])")
        } else if (docMap == res[0]) {
            System.print("%(test) -> %(doc)")
        } else {
            System.print("%(test) -> %(JSON.stringify(res[0]))")
        }
    }
    System.print()
}
