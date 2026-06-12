proc writeText[T](source: T) =
  when T is string:
    echo source
  elif T is File:
    echo source.readAll()
  else:
    echo "Unable to write text for type “", T, "”."

writeText("Hello world!")
writeText(stdin)
writeText(3)      # Emit an error.
