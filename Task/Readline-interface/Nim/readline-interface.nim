import rdstdin, strutils, tables

var history: seq[string]

proc hello =
  echo "Hello World!"
  history.add "hello"

proc hist =
  if history.len == 0:
    echo "no history"
  else:
    for cmd in history:
      echo "  -", cmd
  history.add "hist"

proc help =
  echo "Available commands:"
  echo "  hello"
  echo "  hist"
  echo "  exit"
  echo "  help"
  history.add "help"

const Vfs = {"help": help, "hist": hist, "hello": hello}.toTable

echo "Enter a command, type help for a listing."
while true:
  let line = try:
               readLineFromStdin(">").strip()
             except IOError:
               echo "EOF encountered. Bye."
               break
  if line == "exit": break
  if line notin Vfs:
    echo "Unknown command, try again."
  else:
    Vfs[line]()
