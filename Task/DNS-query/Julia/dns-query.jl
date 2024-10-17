julia> using Sockets

julia> getaddrinfo("www.kame.net")
ip"203.178.141.194"

julia> getaddrinfo("www.kame.net", IPv6)
ip"2001:200:dff:fff1:216:3eff:feb1:44d7"
