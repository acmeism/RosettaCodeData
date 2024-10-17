using SHA

bytes(n::Integer, l::Int) = collect(UInt8, (n >> 8i) & 0xFF for i in l-1:-1:0)

function decodebase58(bc::String, l::Int)
    digits = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    num = big(0)
    for c in bc
        num = num * 58 + search(digits, c) - 1
    end
    return bytes(num, l)
end

function checkbcaddress(addr::String)
    if !(25 ≤ length(addr) ≤ 35) return false end
    bcbytes = decodebase58(addr, 25)
    sha = sha256(sha256(bcbytes[1:end-4]))
    return bcbytes[end-3:end] == sha[1:4]
end

const addresses = Dict(
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" => true,
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j" => false,
    "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9" => true,
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X" => true,
    "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" => false,
    "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" => false,
    "BZbvjr" => false,
    "i55j" => false,
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62!" => false,
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62iz" => false,
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62izz" => false,
    "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nJ9" => false,
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I" => false)

for (addr, corr) in addresses
    println("Address: $addr\nExpected: $corr\tChecked: ", checkbcaddress(addr))
end
