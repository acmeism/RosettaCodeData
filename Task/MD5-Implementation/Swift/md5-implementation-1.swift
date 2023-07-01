    import Foundation
    public class MD5 {
        /** specifies the per-round shift amounts */
        private let s: [UInt32] = [7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
                           5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
                           4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
                           6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21]

        /** binary integer part of the sines of integers (Radians) */
        private let K: [UInt32] = (0 ..< 64).map { UInt32(0x100000000 * abs(sin(Double($0 + 1)))) }

        let a0: UInt32 = 0x67452301
        let b0: UInt32 = 0xefcdab89
        let c0: UInt32 = 0x98badcfe
        let d0: UInt32 = 0x10325476

        private var message: NSData

        //MARK: Public

        public init(_ message: NSData) {
            self.message = message
        }

        public func calculate() -> NSData? {
            var tmpMessage: NSMutableData = NSMutableData(data: message)
            let wordSize = sizeof(UInt32)

            var aa = a0
            var bb = b0
            var cc = c0
            var dd = d0

            // Step 1. Append Padding Bits
            tmpMessage.appendBytes([0x80]) // append one bit (Byte with one bit) to message

            // append "0" bit until message length in bits ≡ 448 (mod 512)
            while tmpMessage.length % 64 != 56 {
                tmpMessage.appendBytes([0x00])
            }

            // Step 2. Append Length a 64-bit representation of lengthInBits
            var lengthInBits = (message.length * 8)
            var lengthBytes = lengthInBits.bytes(64 / 8)
            tmpMessage.appendBytes(reverse(lengthBytes));

            // Process the message in successive 512-bit chunks:
            let chunkSizeBytes = 512 / 8
            var leftMessageBytes = tmpMessage.length
            for var i = 0; i < tmpMessage.length; i = i + chunkSizeBytes, leftMessageBytes -= chunkSizeBytes {
                let chunk = tmpMessage.subdataWithRange(NSRange(location: i, length: min(chunkSizeBytes,leftMessageBytes)))

                // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
                // println("wordSize \(wordSize)");
                var M:[UInt32] = [UInt32](count: 16, repeatedValue: 0)
                for x in 0..<M.count {
                    var range = NSRange(location:x * wordSize, length: wordSize)
                    chunk.getBytes(&M[x], range:range);
                }

                // Initialize hash value for this chunk:
                var A:UInt32 = a0
                var B:UInt32 = b0
                var C:UInt32 = c0
                var D:UInt32 = d0

                var dTemp:UInt32 = 0

                // Main loop
                for j in 0...63 {
                    var g = 0
                    var F:UInt32 = 0

                    switch (j) {
                    case 0...15:
                        F = (B & C) | ((~B) & D)
                        g = j
                        break
                    case 16...31:
                        F = (D & B) | (~D & C)
                        g = (5 * j + 1) % 16
                        break
                    case 32...47:
                        F = B ^ C ^ D
                        g = (3 * j + 5) % 16
                        break
                    case 48...63:
                        F = C ^ (B | (~D))
                        g = (7 * j) % 16
                        break
                    default:
                        break
                    }
                    dTemp = D
                    D = C
                    C = B
                    B = B &+ rotateLeft((A &+ F &+ K[j] &+ M[g]), s[j])
                    A = dTemp
                }

                aa = aa &+ A
                bb = bb &+ B
                cc = cc &+ C
                dd = dd &+ D
            }

            var buf: NSMutableData = NSMutableData();
            buf.appendBytes(&aa, length: wordSize)
            buf.appendBytes(&bb, length: wordSize)
            buf.appendBytes(&cc, length: wordSize)
            buf.appendBytes(&dd, length: wordSize)

            return buf.copy() as? NSData;
        }

        //MARK: Class
        class func calculate(message: NSData) -> NSData?
        {
            return MD5(message).calculate();
        }

        //MARK: Private
        private func rotateLeft(x:UInt32, _ n:UInt32) -> UInt32 {
            return (x &<< n) | (x &>> (32 - n))
        }
    }
