using Nettle

msg = "Rosetta Code"

h = HashState(MD4)
update!(h, msg)
h = hexdigest!(h)

println("\"", msg, "\" => ", h)
