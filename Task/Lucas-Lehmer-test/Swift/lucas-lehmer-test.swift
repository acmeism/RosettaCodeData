import BigInt         // add package attaswift/BigInt from Github
import Darwin

func Eratosthenes(upTo: Int) -> [Int] {

    let maxroot = Int(sqrt(Double(upTo)))

    var isprime = [Bool](repeating: true, count: upTo+1 )
    for i in 2...maxroot {
        if isprime[i] {
            for k in stride(from: upTo/i, through: i, by: -1) {
                if isprime[k] {
                    isprime[i*k] = false }
            }
        }
    }
    var result = [Int]()
    for i in 2...upTo {
        if isprime[i] {
            result.append( i)
        }
    }
    return result
}

func lucasLehmer(_ p: Int) -> Bool {
    let m = BigInt(2).power(p) - 1
    var s = BigInt(4)

    for _ in 0..<p-2 {
        s = ((s * s) - 2) % m
    }

    return s == 0
}

for prime in Eratosthenes(upTo: 128) where lucasLehmer(prime) {
    let mprime = BigInt(2).power(prime) - 1
    print("2^\(prime) - 1 = \(mprime) is prime")
}
