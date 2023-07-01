import std/[sequtils, strutils, tables]

# Description of a Bifid cipher.
type Bifid[N: static Positive] = object
  grid: array[1..N, array[1..N, char]]
  coords: Table[char, (int, int)]

proc initBifid(N: static Positive; text: string): Bifid[N] =
  # Initialize a Bifid cipher.
  assert text.len == N * N
  var row, col = 1
  for c in text:
    result.grid[row][col] = c
    result.coords[c] = (row, col)
    inc col
    if col > N:
      col = 1
      inc row
  if N == 5:
    result.coords['J'] = result.coords['I']

func encrypt(bifid: Bifid; text: string): string =
  ## Encrypt "text" using the given cipher.
  var row1, row2: seq[int]
  for ch in text:
    let coords = bifid.coords[ch]
    row1.add coords[0]
    row2.add coords[1]
  let row = row1 & row2
  for i in countup(0, row.high, 2):
    result.add bifid.grid[row[i]][row[i+1]]

func decrypt(bifid: Bifid; text: string): string =
  ## Decrypt "text" using the given cipher.
  var row: seq[int]
  for ch in text:
    let coords = bifid.coords[ch]
    row.add [coords[0],  coords[1]]
  let m = row.len shr 1
  let row1 = row[0..<m]
  let row2 = row[m..^1]
  for i in 0..<m:
    result.add bifid.grid[row1[i]][row2[i]]

func `$`(bifid: Bifid): string =
  ## Display the Polybius square of a Bifid cipher.
  result = "  " & toSeq(1..bifid.N).join(" ") & '\n'
  for row in 1..bifid.N:
    result.add alignLeft($row, 2) & bifid.grid[row].join(" ") & '\n'

proc runTest(bifid: Bifid; message: string) =
  ## Run the test with given cipher and message.
  echo "Using Polybius square:"
  echo bifid
  echo "Message:   ", message
  let encrypted = bifid.encrypt(message)
  echo "Encrypted: ", encrypted
  let decrypted = bifid.decrypt(encrypted)
  echo "Decrypted: ", decrypted
  echo("\n─────────────────────────")

const
  Message1 = "ATTACKATDAWN"
  Message2 = "FLEEATONCE"
  Message3 = "The invasion will start on the first of January".toUpperAscii.replace(" ")

# Using 5x5 Polybius squares.
const
  Bifid1 = initBifid(5, "ABCDEFGHIKLMNOPQRSTUVWXYZ")
  Bifid2 = initBifid(5, "BGWKZQPNDSIOAXEFCLUMTHYVR")
for (bifid, message) in [(Bifid1, Message1), (Bifid2, Message2),
                         (Bifid2, Message1), (Bifid1, Message3)]:
  runTest(bifid, message)

# Using a 6x6 Polybius square with 26 letters and 10 digits.
const Bifid3 = initBifid(6, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
runTest(Bifid3, Message3)
