import asyncnet, asyncdispatch

proc processClient(client: AsyncSocket) {.async.} =
  while true:
    let line = await client.recvLine()
    await client.send(line & "\c\L")

proc serve() {.async.} =
  var server = newAsyncSocket()
  server.bindAddr(Port(12321))
  server.listen()

  while true:
    let client = await server.accept()
    discard processClient(client)

discard serve()
runForever()
