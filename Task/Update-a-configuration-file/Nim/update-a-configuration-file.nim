import os, re, strutils

let regex = re(r"^(;*)\s*([A-Z0-9]+)\s*([A-Z0-9]*)", {reIgnoreCase, reStudy})

type

  EntryType {.pure.} = enum Empty, Enabled, Disabled, Comment, Ignore

  Entry = object
    etype: EntryType
    name: string
    value: string

  Config = object
    entries: seq[Entry]
    path: string


# Forward reference.
proc addOption*(config: var Config; name, value: string; etype = Enabled)


proc initConfig*(path: string): Config =

  if not path.isValidFilename:
    raise newException(IOError, "invalid file name.")

  result.path = path
  if not path.fileExists: return

  for line in path.lines:
    var line = line.strip
    if line.len == 0:
      result.entries.add Entry(etype: Empty)
    elif line[0] == '#':
      result.entries.add Entry(etype: Comment, value: line)
    else:
      line = line.replace(re"^a-zA-Z0-9\x20;")
      var matches = newSeq[string](3)
      if line.match(regex, matches) and matches[1].len != 0:
        let etype = if matches[0].len == 0: Enabled else: Disabled
        result.addOption(matches[1], matches[2], etype)


proc getOptionIndex(config: Config; name: string): int =
  for i, e in config.entries:
    if e.etype notin [Enabled, Disabled]: continue
    if e.name == name.toUpperAscii:
      return i
  result = -1


proc enableOption*(config: var Config; name: string) =
  let i = config.getOptionIndex(name)
  if i >= 0:
    config.entries[i].etype = Enabled


proc disableOption*(config: var Config; name: string) =
  let i = config.getOptionIndex(name)
  if i >= 0:
    config.entries[i].etype = Disabled


proc setOption*(config: var Config; name, value: string) =
  let i = config.getOptionIndex(name)
  if i >= 0:
    config.entries[i].value = value


proc addOption*(config: var Config; name, value: string; etype = Enabled) =
  config.entries.add Entry(etype: etype, name: name.toUpperAscii, value: value)


proc removeOption*(config: var Config; name: string) =
  let i = config.getOptionIndex(name)
  if i >= 0:
    config.entries[i].etype = Ignore


proc store*(config: Config) =
  let f = open(config.path, fmWrite)
  for e in config.entries:
    case e.etype
    of Empty: f.writeLine("")
    of Enabled: f.writeLine(e.name, ' ', e.value)
    of Disabled: f.writeLine("; ", e.name, ' ', e.value)
    of Comment: f.writeLine(e.value)
    of Ignore: discard


when isMainModule:

  var cfg = initConfig("update_demo.config")
  cfg.enableOption("seedsremoved")
  cfg.disableOption("needspeeling")
  cfg.setOption("numberofbananas", "1024")
  cfg.addOption("numberofstrawberries", "62000")
  cfg.store()
