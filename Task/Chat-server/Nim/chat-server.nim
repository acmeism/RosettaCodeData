import asyncnet, asyncdispatch

type TClient = tuple[socket: AsyncSocket, name: string]
var clients: seq[Client] = @[]

proc sendOthers(client: Client, line: string) {.async.} =
  for c in clients:
    if c != client:
      await c.socket.send(line & "\c\L")

proc processClient(socket: AsyncSocket) {.async.} =
  await socket.send("Please enter your name: ")
  let client: Client = (socket, await socket.recvLine())

  clients.add client
  discard client.sendOthers "+++ " & client.name & " arrived +++"

  while true:
    let line = await client.socket.recvLine()
    if line == "":
      discard client.sendOthers "--- " & client.name & " leaves ---"
      break
    discard client.sendOthers client.name & "> " & line

  for i,c in clients:
    if c == client:
      clients.del i
      break

proc serve() {.async.} =
  var server = newAsyncSocket()
  server.bindAddr(Port(4004))
  server.listen()

  while true:
    let socket = await server.accept()
    discard processClient socket

discard serve()
runForever()
