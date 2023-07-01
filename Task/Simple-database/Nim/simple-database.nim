import algorithm, json, os, strformat, strutils, times

const FileName = "simdb.json"

type

  Item = object
    name: string
    date: string
    category: string

  Database = seq[Item]

  DbError = object of CatchableError


proc load(): Database =
  if fileExists(FileName):
    let node = try: FileName.parseFile()
               except JsonParsingError:
                 raise newException(DbError, getCurrentExceptionMsg())
    result = node.to(DataBase)


proc store(db: Database) =
  try:
    FileName.writeFile $(%* db)
  except IOError:
    quit "Unable to save database.", QuitFailure


proc addItem(args: seq[string]) =
  var db = try: load()
           except DbError: quit getCurrentExceptionMsg(), QuitFailure

  let date = now().format("yyyy-MM-dd HH:mm:ss")
  let cat = if args.len == 2: args[1] else: "none"
  db.add Item(name: args[0], date: date, category: cat)
  db.store()


proc printLatest(args: seq[string]) =
  let db = try: load()
           except DbError: quit getCurrentExceptionMsg(), QuitFailure
  if db.len == 0:
    echo "No entries in database."
    return

  # No need to sort db as items are added chronologically.
  if args.len == 1:
    var found = false
    for item in reversed(db):
      if item.category == args[0]:
        echo item
        found = true
        break
    if not found:
      echo &"There are no items for category '{args[0]}'"
  else:
    echo db[^1]


proc printAll() =
  let db = try: load()
           except DbError: quit getCurrentExceptionMsg(), QuitFailure
  if db.len == 0:
    echo "No entries in database."
    return
  for item in db:
    echo item


proc printUsage() =
  echo &"""
Usage:
  {getAppFilename().splitPath().tail} cmd [categoryName]

  add     add item, followed by optional category
  latest  print last added item(s), followed by optional category
  all     print all

  For instance: add "some item name" "some category name"
  """
  quit QuitFailure


if paramCount() notin 1..3: printUsage()

var params = commandLineParams()
let command = params[0].toLowerAscii
params.delete(0)
case command
of "add":
  if params.len == 0: printUsage()
  addItem(params)
of "latest":
  if params.len > 1: printUsage()
  printLatest(params)
of "all":
  if params.len != 0: printUsage()
  printAll()
