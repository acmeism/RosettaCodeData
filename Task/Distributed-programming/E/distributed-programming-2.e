def [uri] := interp.getArgs()
introducer.onTheAir()
def sturdyRef := <captp>.sturdyFromURI(uri)
def logService := sturdyRef.getRcvr()

logService <- log("foot")
logService <- log("shoe")

println("Searching...")
when (def result := logService <- search("foo")) -> {
  for [time, line] in result {
    println(`At $time: $line`)
  }
}
