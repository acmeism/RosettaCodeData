    julia> using Sockets # for IP types

    julia> MyUnion = Union{Int64, String, Float64, IPv4, IPv6}
    Union{Float64, Int64, IPv4, IPv6, String}

    julia> arr = MyUnion[2, 4.8, ip"192.168.0.0", ip"::c01e:fc9a", "Hello"]
    5-element Array{Union{Float64, Int64, IPv4, IPv6, String},1}:
     2
     4.8
      ip"192.168.0.0"
      ip"::c01e:fc9a"
      "Hello"

