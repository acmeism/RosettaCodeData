const canonicalize = s => {

    // Prepare a DataView over a 16 Byte Array buffer.
    // Initialised to all zeros.
    const dv = new DataView(new ArrayBuffer(16));

    // Get the ip-address and cidr components
    const [ip, cidr] = s.split('/');

    // Make sure the cidr component is a usable int, and
    // default to 32 if it does not exist.
    const cidrInt = parseInt(cidr || 32, 10);

    // Populate the buffer with uint8 ip address components.
    // Use zero as the default for shorthand pool definitions.
    ip.split('.').forEach(
        (e, i) => dv.setUint8(i, parseInt(e || 0, 10))
    );

    // Grab the whole buffer as a uint32
    const ipAsInt = dv.getUint32(0);

    // Zero out the lower bits as per the CIDR number.
    const normIpInt = (ipAsInt >> 32 - cidrInt) << 32 - cidrInt;

    // Plonk it back into the buffer
    dv.setUint32(0, normIpInt);

    // Read each of the uint8 slots in the buffer and join them with a dot.
    const canonIp = [...'0123'].map((e, i) => dv.getUint8(i)).join('.');

    // Attach the cidr number to the back of the normalised IP address.
    return [canonIp, cidrInt].join('/');
  }

  const test = s => console.log(s, '->', canonicalize(s));
  [
    '255.255.255.255/10',
    '87.70.141.1/22',
    '36.18.154.103/12',
    '62.62.197.11/29',
    '67.137.119.181/4',
    '161.214.74.21/24',
    '184.232.176.184/18',
    '10.207.219.251/32',
    '10.207.219.251',
    '110.200.21/4',
    '10..55/8',
    '10.../8'
  ].forEach(test)
