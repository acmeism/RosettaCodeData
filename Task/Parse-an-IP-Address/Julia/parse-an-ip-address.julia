const testdata = ["127.0.0.1", "127.0.0.1:80", "::1", "[::1]:80",
                  "2605:2700:0:3::4713:93e3", "[2605:2700:0:3::4713:93e3]:80",
                  "::ffff:192.168.173.22", "[::ffff:192.168.173.22]:80",
                  "1::", "[1::]:80", "::", "[::]:80"]

maybev4(ip) = search(ip, '.') > 0 && length(matchall(r":", ip)) < 2
maybev6(ip) = length(matchall(r":", ip)) > 1

function parseip(ip)
    if (mat = match(r"^\[([:.\da-fA-F]+)\]:(\d+)$", ip))!= nothing ||
       (mat = match(r"^([\d.]+)[:/](\d+)$", ip)) != nothing
        port = mat.captures[2]
        ip = mat.captures[1]
    else
        port = "none"
    end
    if maybev4(ip)
        println("Processing ip v4 $ip")
        iphex = hex(Int(Base.IPv4(ip)))
        addresspace = "IPv4"
    elseif maybev6(ip)
        println("Processing ip v6 $ip")
        iphex = hex(UInt128(Base.IPv6(ip)))
        addresspace = "IPv6"
    else
        throw("Bad IP address argument $ip")
    end
    iphex, addresspace, port
end

for ip in testdata
    hx, add, por = parseip(ip)
    println("For input $ip, IP in hex is $hx, address space $add, port $por.")
end
