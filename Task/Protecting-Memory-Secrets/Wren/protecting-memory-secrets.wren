import "io" for Stdin
import "./crypto" for Sha256

// Ensure input is not echoed or buffered
Stdin.isRaw = true

// Obtain secret from terminal input as a byte list
System.print("Enter a secret word and press return:")
var bytes = []
while (true) {
    var b = Stdin.readByte()
    if (b == 13) break
    bytes.add(b)
}

// Encrypt bytes and display on terminal
System.print(Sha256.digest(bytes))

// Zero out bytes
for (i in 0...bytes.count) bytes[i] = 0

// Check it worked
System.print(bytes)

// Make byte list eligible for GC
bytes = null

// Force an immediate GC
System.gc()

// Restore normal input before exit
Stdin.isRaw = false
