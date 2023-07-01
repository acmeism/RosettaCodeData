import os, nanomsg

proc sendMsg(s: cint, msg: string) =
  echo "SENDING \"",msg,"\""
  let bytes = s.send(msg.cstring, msg.len + 1, 0)
  assert bytes == msg.len + 1

proc recvMsg(s: cint) =
  var buf: cstring
  let bytes = s.recv(addr buf, MSG, 0)
  if bytes > 0:
    echo "RECEIVED \"",buf,"\""
    discard freemsg buf

proc sendRecv(s: cint, msg: string) =
  var to: cint = 100
  discard s.setSockOpt(SOL_SOCKET, RCVTIMEO, addr to, sizeof to)
  while true:
    s.recvMsg
    sleep 1000
    s.sendMsg msg

proc node0(url: string) =
  var s = socket(AF_SP, nanomsg.PAIR)
  assert s >= 0
  let res = s.bindd url
  assert res >= 0
  s.sendRecv "node0"
  discard s.shutdown 0

proc node1(url: string) =
  var s = socket(AF_SP, nanomsg.PAIR)
  assert s >= 0
  let res = s.connect url
  assert res >= 0
  s.sendRecv "node1"
  discard s.shutdown 0

if paramStr(1) == "node0":
  node0 paramStr(2)
elif paramStr(1) == "node1":
  node1 paramStr(2)
