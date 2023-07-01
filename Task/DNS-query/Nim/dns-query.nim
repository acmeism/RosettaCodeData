import nativesockets

iterator items(ai: ptr AddrInfo): ptr AddrInfo =
  var current = ai
  while current != nil:
    yield current
    current = current.aiNext

proc main() =
  let addrInfos = getAddrInfo("www.kame.net", Port 80, AfUnspec)
  defer: freeAddrInfo addrInfos

  for i in addrInfos:
    echo getAddrString i.aiAddr

when isMainModule: main()
