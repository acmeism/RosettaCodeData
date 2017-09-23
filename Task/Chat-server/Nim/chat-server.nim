import asyncnet, asyncdispatch

type
  Client = tuple
    socket: AsyncSocket
    name: string
    connected: bool

var clients {.threadvar.}: seq[Client]

proc sendOthers(client: Client, line: string) {.async.} =
  for c in clients:
    if c != client and c.connected:
      await c.socket.send(line & "\c\L")

proc processClient(socket: AsyncSocket) {.async.} =
  await socket.send("Please enter your name: ")
  var client: Client = (socket, await socket.recvLine(), true)

  clients.add(client)
  asyncCheck client.sendOthers("+++ " & client.name & " arrived +++")

  while true:
    let line = await client.socket.recvLine()
    if line == "":
      asyncCheck client.sendOthers("--- " & client.name & " leaves ---")
      client.connected = false
      return
    asyncCheck client.sendOthers(client.name & "> " & line)

proc serve() {.async.} =
  clients = @[]
  var server = newAsyncSocket()
  server.bindAddr(Port(4004))
  server.listen()

  while true:
    let socket = await server.accept()
    asyncCheck processClient(socket)

asyncCheck serve()
runForever()
