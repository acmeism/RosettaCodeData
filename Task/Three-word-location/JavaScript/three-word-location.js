function toWord(w) {
    return `W${w.toString().padStart(5, '0')}`;
}

function fromWord(ws) {
    return parseInt(ws.substring(1), 10);
}

function main() {
    console.log("Starting figures:");
    let lat = 28.3852;
    let lon = -81.5638;
    console.log(`  latitude = ${lat.toFixed(4)}, longitude = ${lon.toFixed(4)}`);

    // Convert lat and lon to positive integers
    let ilat = Math.floor(lat * 10000 + 900000);
    let ilon = Math.floor(lon * 10000 + 1800000);

    // Build 43-bit integer comprising 21 bits (lat) and 22 bits (lon)
    // JavaScript uses 64-bit floats for all numbers, but bitwise operations are 32-bit.
    // To handle 43 bits, we use BigInt.
    let latlon = (BigInt(ilat) << 22n) + BigInt(ilon);

    // Isolate relevant bits
    let w1 = Number((latlon >> 28n) & 0x7fffn);
    let w2 = Number((latlon >> 14n) & 0x3fffn);
    let w3 = Number(latlon & 0x3fffn);

    // Convert to word format
    let w1s = toWord(w1);
    let w2s = toWord(w2);
    let w3s = toWord(w3);

    // Print the results
    console.log("\nThree word location is:");
    console.log(`  ${w1s} ${w2s} ${w3s}`);

    // Reverse the procedure
    w1 = fromWord(w1s);
    w2 = fromWord(w2s);
    w3 = fromWord(w3s);

    latlon = (BigInt(w1) << 28n) | (BigInt(w2) << 14n) | BigInt(w3);
    ilat = Number(latlon >> 22n);
    ilon = Number(latlon & 0x3fffffn);

    lat = (ilat - 900000) / 10000;
    lon = (ilon - 1800000) / 10000;

    // Print the results
    console.log("\nAfter reversing the procedure:");
    console.log(`  latitude = ${lat.toFixed(4)}, longitude = ${lon.toFixed(4)}`);
}

main();

