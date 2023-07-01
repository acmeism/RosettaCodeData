import Foundation
import CryptoKit

extension String {
    func hexdata() -> Data {
        Data(stride(from: 0, to: count, by: 2).map {
            let a = index(startIndex, offsetBy: $0)
            let b = index(after: a)
            return UInt8(self[a ... b], radix: 16)!
        })
    }
}

DispatchQueue.concurrentPerform(iterations: 26) { (a) in
    let goal1 = "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad".hexdata()
    let goal2 = "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b".hexdata()
    let goal3 = "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f".hexdata()
    var letters: [UInt8] = [(UInt8)(a + 97), 0, 0, 0, 0]
    for b: UInt8 in 97...122 {
        letters[1] = b
        for c: UInt8 in 97...122 {
            letters[2] = c
            for d: UInt8 in 97...122 {
                letters[3] = d
                for e: UInt8 in 97...122 {
                    letters[4] = e
                    let digest = SHA256.hash(data: letters)
                    if digest == goal1 || digest == goal2 || digest == goal3 {
                        let password = String(bytes: letters, encoding: .ascii)!
                        let hexhash = digest.map { String(format: "%02x", $0) }.joined()
                        print("\(password) => \(hexhash)")
                    }
                }
            }
        }
    }
}
