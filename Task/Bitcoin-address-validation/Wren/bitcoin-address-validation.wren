import "/crypto" for Sha256
import "/str" for Str
import "/fmt" for Conv, Fmt

class Bitcoin {
    static alphabet_ { "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" }

    static contentEquals_(ba1, ba2) {
        if (ba1.count != ba2.count) return false
        return !(0...ba1.count).any { |i| ba1[i] != ba2[i] }
    }

    static decodeBase58_(input) {
        var output = List.filled(25, 0)
        for (c in input) {
            var p = alphabet_.indexOf(c)
            if (p == -1) return null
            for (j in 24..1) {
                p = p +  58 * output[j]
                output[j] = p % 256
                p = p >> 8
            }
            if (p != 0) return null
        }
        return output
    }

    static sha256_(data, start, len, recursion) {
        if (recursion == 0) return data
        var md = Sha256.digest(data[start...start+len])
        md = Str.chunks(md, 2).map { |x| Conv.atoi(x, 16) }.toList
        return sha256_(md, 0, 32, recursion-1)
    }

    static validateAddress(address) {
        var len = address.count
        if (len < 26 || len > 35) return false
        var decoded = decodeBase58_(address)
        if (!decoded) return false
        var hash = sha256_(decoded, 0, 21, 2)
        return contentEquals_(hash[0..3], decoded[21..24])
    }
}

var addresses = [
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j",
    "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9",
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X",
    "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
    "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
    "BZbvjr",
    "i55j",
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62!",
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62iz",
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62izz",
    "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nJ9",
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I"
]
for (address in addresses) {
    Fmt.print("$-36s -> $s", address, Bitcoin.validateAddress(address) ? "valid" : "invalid")
}
