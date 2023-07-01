import net
import strutils


proc canonicalize*(address: var IpAddress; nbits: Positive) =
  ## Canonicalize an IP address.

  var zbits = 32 - nbits    # Number of bits to reset.

  # We process byte by byte which avoids byte order issues.
  for idx in countdown(address.address_v4.high, address.address_v4.low):
    if zbits == 0:
      # No more bits to reset.
      break
    if zbits >= 8:
      # Reset the current byte and continue with the remaining bits.
      address.address_v4[idx] = 0
      dec zbits, 8
    else:
      # Use a mask to reset the bits.
      address.address_v4[idx] = address.address_v4[idx] and (0xff'u8 shl zbits)
      zbits = 0

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import strformat

  var ipAddress: IpAddress
  var nbits: int

  for address in ["87.70.141.1/22", "36.18.154.103/12", "62.62.197.11/29",
                  "67.137.119.181/4", "161.214.74.21/24", "184.232.176.184/18"]:

    # Parse the address.
    let parts = address.split('/')
    try:
      ipAddress = parseIpAddress(parts[0])
      if ipAddress.family == IPV6:
        raise newException(ValueError, "")
    except ValueError:
      echo "Invalid IP V4 address: ", parts[0]
      quit(QuitFailure)

    # Check the number of bits.
    try:
      nbits = parseInt(parts[1])
      if nbits notin 1..32:
        raise newException(ValueError, "")
    except ValueError:
      echo "Invalid number of bits: ", parts[1]
      quit(QuitFailure)

    # Canonicalize the address and display the result.
    ipAddress.canonicalize(nbits)
    echo &"{address:<18}  ⇢  {ipAddress}/{nbits}"
