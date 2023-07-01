import net, sequtils, strscans, strutils

const NoPort = -1

func parseIpAddressAndPort(str: string): tuple[ipAddr: IpAddress; port: int] =
  var ipString: string
  var port: int
  if str.scanf("[$+]:$i", ipString, port):
    # IP v6 address with port.
    return (ipString.parseIpAddress(), port)
  if '.' in str and str.scanf("$+:$i", ipString, port):
    # IP v4 address with port.
    return (ipString.parseIpAddress(), port)
  # IP address without port.
  result = (str.parseIpAddress(), NoPort)


const Inputs = ["127.0.0.1", "127.0.0.1:80",
                "::1", "[::1]:80",
                "2605:2700:0:3::4713:93e3",
                "[2605:2700:0:3::4713:93e3]:80"]

# Room to reserve to display the input.
const InputSize = Inputs.mapIt(it.len).foldl(max(a, b)) + 2

echo "Input".alignLeft(InputSize), "Address".align(32), "  Space", "  Port"

for input in Inputs:
  try:
    let (ipAddress, port) = input.parseIpAddressAndPort()
    let portStr = if port == NoPort: "" else: $port
    case ipAddress.family
    of IPv6:
      echo input.alignLeft(InputSize),
           ipAddress.address_v6.map(toHex).join().align(32),
           "IP v6".align(7),
           portStr.align(6)
    of IPv4:
      echo input.alignLeft(InputSize),
           ipAddress.address_v4.map(toHex).join().align(32),
           "IP v4".align(7),
           portStr.align(6)

  except ValueError:
    echo "Invalid IP address: ", input
