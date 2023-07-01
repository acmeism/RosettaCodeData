import strutils, strformat

func is_isbn*(s: string): bool =
  var sum, len: int
  for c in s:
    if is_digit(c):
      sum += (ord(c) - ord('0')) * (if len mod 2 == 0: 1 else: 3)
      len += 1
    elif c != ' ' and c != '-':
      return false
  return (len == 13) and (sum mod 10 == 0)

when is_main_module:
  let isbns = [ "978-1734314502", "978-1734314509",
                "978-1788399081", "978-1788399083" ]
  for isbn in isbns:
    var quality: string = if is_isbn(isbn): "good" else: "bad"
    echo &"{isbn}: {quality}"
