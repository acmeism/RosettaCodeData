package main

V4 :: distinct [4]u8
V6 :: distinct string

IpAddr :: union { V4, V6 }

ip1, ip2 : IpAddr

main :: proc() {
  ip1 = V4{127, 0, 0, 1}
  ip2 = V6("::1")
}
