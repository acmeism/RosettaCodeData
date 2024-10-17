using Sockets

function canonCIDR(cidr::String)
    cidr = replace(cidr, r"\.(\.|\/)" => s".0\1") # handle ..
    cidr = replace(cidr, r"\.(\.|\/)" => s".0\1") # handle ...
    ip = split(cidr, "/")
    dig = length(ip) > 1 ? 2^(32 - parse(UInt8, ip[2])) : 1
    ip4 = IPv4(UInt64(IPv4(ip[1])) & (0xffffffff - dig + 1))
    return length(ip) == 1 ? "$ip4/32" : "$ip4/$(ip[2])"
end

println(canonCIDR("87.70.141.1/22"))
println(canonCIDR("100.68.0.18/18"))
println(canonCIDR("10.4.30.77/30"))
println(canonCIDR("10.207.219.251/32"))
println(canonCIDR("10.207.219.251"))
println(canonCIDR("110.200.21/4"))
println(canonCIDR("10..55/8"))
println(canonCIDR("10.../8"))
