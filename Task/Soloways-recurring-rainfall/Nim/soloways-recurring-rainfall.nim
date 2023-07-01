import std/[strformat, strutils]

const EndValue = 99999


var sum, count = 0.0

while true:

  var value: int

  # Read input until a valid integer if found.
  var input: string
  while true:
    stdout.write &"Enter an integer value, {EndValue} to terminate: "
    stdout.flushFile()
    try:
      input = stdin.readLine()
      value = input.parseInt()
      break
    except ValueError:
      echo &"Expected an integer: got “{input}”"
    except EOFError:
      quit "\nEncountered end of file. Exiting.", QuitFailure

  # Process value.
  if value == EndValue:
    echo "End of processing."
    break
  count += 1
  sum += value.toFloat
  echo &"  Current average is {sum / count}."
