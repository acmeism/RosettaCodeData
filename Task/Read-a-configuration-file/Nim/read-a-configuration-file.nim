import re, strformat, strutils, tables

var configs: OrderedTable[string, seq[string]]
var parsed: seq[string]

for line in "demo.config".lines():
  let line = line.strip()
  if line != "" and not line.startswith(re"#|;"):
    parsed = line.split(re"\s*=\s*|\s+", 1)
    configs[parsed[0].toLower()] = if len(parsed) > 1: parsed[1].split(re"\s*,\s*") else: @[]

for key in ["fullname", "favouritefruit", "needspeeling", "seedsremoved", "otherfamily"]:
  if not configs.hasKey(key):
    echo(&"{key} = false")
  else:
    case len(configs[key])
    of 0:
      echo(&"{key} = true")
    of 1:
      echo(&"{key} = {configs[key][0]}")
    else:
      for i, v in configs[key].pairs():
        echo(&"{key}({i+1}) = {v}")
