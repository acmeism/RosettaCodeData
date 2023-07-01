import strutils, rdstdin

proc menu(xs: openArray[string]) =
  for i, x in xs: echo "  ", i, ") ", x

proc ok(reply: string; count: Positive): bool =
  try:
    let n = parseInt(reply)
    return 0 <= n and n < count
  except: return false

proc selector(xs: openArray[string]; prompt: string): string =
  if xs.len == 0: return ""
  var reply = "-1"
  while not ok(reply, xs.len):
    menu(xs)
    reply = readLineFromStdin(prompt).strip()
  return xs[parseInt(reply)]

const xs = ["fee fie", "huff and puff", "mirror mirror", "tick tock"]
let item = selector(xs, "Which is from the three pigs: ")
echo "You chose: ", item
