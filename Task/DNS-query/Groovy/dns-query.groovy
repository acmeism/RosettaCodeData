def addresses = InetAddress.getAllByName('www.kame.net')
println "IPv4: ${addresses.find { it instanceof Inet4Address }?.hostAddress}"
println "IPv6: ${addresses.find { it instanceof Inet6Address }?.hostAddress}"
