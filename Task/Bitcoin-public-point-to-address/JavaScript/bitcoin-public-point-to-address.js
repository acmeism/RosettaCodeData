const crypto = require('crypto');

const digits58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

function b58(n) {
    if (n === 0n) return '';
    return b58(n / 58n) + digits58[Number(n % 58n)];
}

function publicPointToAddress(x, y) {
    // Convert hex strings to buffers
    const xBuffer = Buffer.from(x, 'hex');
    const yBuffer = Buffer.from(y, 'hex');

    // Create uncompressed public key format (0x04 + x + y)
    const publicKey = Buffer.concat([Buffer.from([0x04]), xBuffer, yBuffer]);

    // SHA256 hash
    const sha256Hash = crypto.createHash('sha256').update(publicKey).digest();

    // RIPEMD160 hash
    const ripemd160Hash = crypto.createHash('ripemd160').update(sha256Hash).digest();

    // Add version byte (0x00 for mainnet)
    const versionedHash = Buffer.concat([Buffer.from([0x00]), ripemd160Hash]);

    // Double SHA256 for checksum
    const checksum = crypto.createHash('sha256')
        .update(crypto.createHash('sha256').update(versionedHash).digest())
        .digest()
        .slice(0, 4);

    // Combine versioned hash with checksum
    const addressBytes = Buffer.concat([versionedHash, checksum]);

    // Convert to BigInt for base58 encoding
    let n = 0n;
    for (let i = 0; i < addressBytes.length; i++) {
        n = (n << 8n) | BigInt(addressBytes[i]);
    }

    return b58(n);
}

// Test with the provided values
if (require.main === module) {
    const address = publicPointToAddress(
        '50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352',
        '2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6'
    );
    console.log(address);
}
