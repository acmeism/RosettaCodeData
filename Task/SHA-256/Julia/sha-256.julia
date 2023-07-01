msg = "Rosetta code"

using Nettle
digest = hexdigest("sha256", msg)

# native
using SHA
digest1 = join(num2hex.(sha256(msg)))

@assert digest == digest1
