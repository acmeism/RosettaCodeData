import os, strutils

type CopyPastaError = object of CatchableError

template raiseError(message: string, linenum = 0) =
  let prefix = if linenum != 0: "Line $1: ".format(linenum) else: ""
  raise newException(CopyPastaError, prefix & message)


proc copyPasta() =
  ## Load and execute a program.

  var clipboard: string

  if paramCount() != 1:
      echo "usage: ", getAppFilename().lastPathPart, " filename.cp"
      quit QuitFailure

  let path = paramStr(1)
  let code = try: path.readFile()
             except IOError: raiseError("Unable to read file “$1”.".format(path))

  let lines = code.splitLines()

  var linenum = 1   # Starting at index one for line number.
  while linenum <= lines.len:
    let command = lines[linenum - 1].strip()
    case command

    of "Copy":
      if linenum == lines.len: raiseError("missing string to copy.", linenum)
      clipboard.add lines[linenum]

    of "CopyFile":
      if linenum == lines.len: raiseError("missing file to copy from.", linenum)
      let fpath = lines[linenum]
      if fpath == "TheF*ckingCode":
        clipboard.add code
      else:
        let text = try: fpath.readFile()
                   except IOError: raiseError("unable to read file “$1”.".format(fpath), linenum)
        clipboard.add text

    of "Duplicate":
      if linenum == lines.len: raiseError("missing number of repetitions.", linenum)
      let n = try: lines[linenum].parseInt()
              except: raiseError("wrong number of repetitions.", linenum + 1)
      clipboard.add repeat(clipboard, n)

    of "Pasta!":
      stdout.write clipboard
      break

    of "":  # Empty mine: skip.
      inc linenum
      continue

    else:
      raiseError("unknown command “$1”.".format(command), linenum)

    inc linenum, 2

try:
  copyPasta()
except CopyPastaError:
  quit getCurrentExceptionMsg(), QuitFailure
