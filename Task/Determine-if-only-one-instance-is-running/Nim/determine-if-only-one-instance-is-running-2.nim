import options, os
from net import newSocket, bindUnix
from nativesockets import AF_UNIX, SOCK_DGRAM, IPPROTO_IP
from posix import EADDRINUSE

const sockAddr = "\0com.myapp.sock" # Linux will delete this when the application ends
# notice the prefixed null byte, it's the Linux abstract namespace

proc server()=
  echo "Unique instance detected"

proc client()=
  echo "Duplicate instance detected"

when isMainModule:
  var
    sock = newSocket(AF_UNIX, SOCK_DGRAM, IPPROTO_IP)
    isUnique: Option[bool]

  try:
    sock.bindUnix(sock_addr)
    is_unique = some true
  except OSError:
      if cint(osLastError()) == EADDRINUSE:
        isUnique = some false
      else:
        raise getCurrentException()

  if unlikely is_unique.isNone:
    echo "Error detecting uniqueness" # unreachable
  else:
    if isUnique.unsafeGet():
      server()
    else:
      client()
