proc encode*(s: string; upper: bool): string =
  ## Encode string "s" into a GSTrans string using
  ## either lower case letters or upper case letters.

  proc encode(c: char): string =
    ## Encode character "c" into a GSTrans string.
    result = case c
             of '\1'..'\26': '|' & (if upper: chr(ord(c) + 64) else: chr(ord(c) + 96))
             of '\0', '\27'..'\31': '|' & chr(ord(c) + 64)
             of '"': "|\""
             of '<': "|<"
             of '|': "||"
             of '\127': "|?"
             of '\128'..'\255': "|!" & encode(chr(ord(c) - 128))
             else: $c

  if s.len == 0:
    raise newException(ValueError, "argument must be a non-empty string.")

  # Ignore any outer quotation marks
  let (first, last) = if s.len > 1 and s[0] == '"' and s[^1] == '"': (1, s.high - 1)
                      else: (0, s.high)

  for i in first..last:
    result.add encode(s[i])


proc decode*(s: string): string =
  ## Decode GSTrans string "s" into a string.

  proc decode(c: char): char =
    ## Decode character "c" after '|'.
    result = case c
             of '"', '<', '|': c
             of '?': '\127'
             of '@'..'_': chr(ord(c) - 64)
             of '`': '\31'
             of 'a'..'{', '}', '~' : chr(ord(c) - 96)
             else: c

  let lg = s.len
  var i = 0
  while i < lg:
    if s[i] != '|':
      result.add s[i]
      inc i
    elif i < lg - 1 and s[i + 1] != '!':
      result.add decode(s[i + 1])
      inc i, 2
    elif i < lg - 2 and s[i + 2] != '|':
      result.add chr(128 + ord(s[i + 2]))
      inc i, 3
    elif i < lg - 3 and s[i + 2] == '|':
      result.add chr(128 + ord(decode(s[i + 3])))
      inc i, 4
    else:
      inc i


when isMainModule:

  import std/strformat

  const
    Strings = ["\fHello\a\n\r", "\r\n\0\x05\xf4\r\xff"]
    Uppers = [true, false]

  for i, s in Strings:
    var t: string
    for c in s: t.addEscapedChar(c)
    let u = Uppers[i]
    let encoded = s.encode(u)
    let decoded = encoded.decode()
    var d: string
    for c in decoded: d.addEscapedChar(c)
    echo "string: ", t
    echo &"encoded ({(if u: \"upper\" else: \"lower\")}) : {encoded}"
    echo "decoded : ", d
    echo "string == decoded ? ", decoded == s
    echo()

  const JStrings = ["ALERT|G", "wert↑", "@♂aN°$ª7Î", "ÙC▼æÔt6¤☻Ì", "\"@)Ð♠qhýÌÿ",
                    "+☻#o9$u♠©A", "♣àlæi6Ú.é", "ÏÔ♀È♥@ë", r"Rç÷\%◄MZûhZ", "ç>¾AôVâ♫↓P"]

  echo "Julia strings: string -> encoded (upper) <- decoded (same or different)\n"
  for s in JStrings:
    let encoded = s.encode(true)
    let decoded = encoded.decode()
    let same = s == decoded
    echo &"  {s} -> {encoded} <- {decoded} ({(if same: \"same\" else: \"different\")})"
