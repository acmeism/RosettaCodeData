import "/crypto" for Sha256

var hashes = [
    "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
    "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
    "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"
]

var findHash = Fn.new { |i|
    var bytes = List.filled(5, 0)
    var r = 97..122
    bytes[0] = i
    for (j in r) {
        bytes[1] = j
        for (k in r) {
            bytes[2] = k
            for (l in r) {
                bytes[3] = l
                for (m in r) {
                    bytes[4] = m
                    var d = Sha256.digest(bytes)
                    for (hash in hashes) {
                        if (hash == d) {
                            var s = bytes.map { |b| String.fromByte(b) }.join()
                            System.print("%(s) => %(d)")
                            hashes.remove(hash)
                            if (hashes.count == 0) return
                        }
                    }
                }
            }
        }
    }
}

for (i in 0..25) {
    var fib = Fiber.new(findHash)
    fib.call(97+i)
}
