import os
import parseopt

proc main =
  # Directly accessing the app name and parameters
  echo "app name: ", getAppFilename().extractFilename()
  echo "# parameters: ", paramCount()
  for ii in 1 .. paramCount():    # 1st param is at index 1
    echo "param ", ii, ": ", paramStr(ii)

  echo ""

  # Using parseopt module to extract short and long options and arguments
  var argCtr : int

  for kind, key, value in getOpt():
    case kind
    of cmdArgument:
      echo "Got arg ", argCtr, ": \"", key, "\""
      argCtr.inc

    of cmdLongOption, cmdShortOption:
      case key
      of "v", "n", "z", "w":
        echo "Got a \"", key, "\" option with value: \"", value, "\""
      else:
        echo "Unknown option: ", key

    of cmdEnd:
      discard


main()
