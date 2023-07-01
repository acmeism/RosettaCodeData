import algorithm, sequtils, strutils

const

  LeftDigits = ["   ## #",
                "  ##  #",
                "  #  ##",
                " #### #",
                " #   ##",
                " ##   #",
                " # ####",
                " ### ##",
                " ## ###",
                "   # ##"]

  RightDigits = LeftDigits.mapIt(it.multiReplace(("#", " "), (" ", "#")))

  EndSentinel = "# #"
  MidSentinel = " # # "


template isEven(n: int): bool = (n and 1) == 0


proc decodeUPC(input: string) =

  #.................................................................................................

  proc decode(candidate: string): tuple[valid: bool, list: seq[int]] =

    const Invalid = (false, @[])

    var pos = 0
    var next = pos + EndSentinel.len
    if candidate[pos..<next] == EndSentinel:
      pos = next
    else:
      return Invalid

    for _ in 1..6:
      next = pos + 7
      let i = LeftDigits.find(candidate[pos..<next])
      if i >= 0:
        result.list.add i
        pos = next
      else:
        return Invalid

    next = pos + MidSentinel.len
    if candidate[pos..<next] == MidSentinel:
      pos = next
    else:
      return Invalid

    for _ in 1..6:
      next = pos + 7
      let i = RightDigits.find(candidate[pos..<next])
      if i >= 0:
        result.list.add i
        pos = next
      else:
        return Invalid

    next = pos + EndSentinel.len
    if candidate[pos..<next] == EndSentinel:
      pos = next
    else:
      return Invalid

    var sum = 0
    for i, v in result.list:
      sum += (if i.isEven: 3 * v else: v)
    result.valid = sum mod 10 == 0

  #.................................................................................................

  var candidate = input.strip()
  let output = candidate.decode()
  if output.valid:
    echo output.list.join(", ")
  else:
    candidate.reverse()
    let output = candidate.decode()
    if output.valid:
      echo output.list.join(", "), " Upside down"
    elif output.list.len == 0:
      echo "Invalid digit(s)"
    else:
      echo "Invalid checksum: ", output.list.join(", ")


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  const BarCodes = [
    "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
    "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
    "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
    "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
    "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
    "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
    "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
    "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
    "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
    "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
    ]

  for barcode in BarCodes:
    barcode.decodeUPC()
