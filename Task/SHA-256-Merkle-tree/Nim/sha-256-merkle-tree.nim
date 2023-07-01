import nimcrypto

const BlockSize = 1024

var hashes: seq[MDigest[256]]

let f = open("title.png")
var buffer: array[BlockSize, byte]
while true:
  let n = f.readBytes(buffer, 0, BlockSize)
  if n == 0: break
  hashes.add sha256.digest(buffer[0].addr, n.uint)
f.close()

var ctx: sha256
while hashes.len != 1:
  var newHashes: seq[MDigest[256]]
  for i in countup(0, hashes.high, 2):
    if i < hashes.high:
      ctx.init()
      ctx.update(hashes[i].data)
      ctx.update(hashes[i + 1].data)
      newHashes.add ctx.finish()
      ctx.clear()
    else:
      newHashes.add hashes[i]
  hashes= newHashes

echo hashes[0]
