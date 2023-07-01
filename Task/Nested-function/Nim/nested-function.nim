proc makeList(separator: string): string =
  var counter = 1

  proc makeItem(item: string): string =
    result = $counter & separator & item & "\n"
    inc counter

  makeItem("first") & makeItem("second") & makeItem("third")

echo $makeList(". ")
