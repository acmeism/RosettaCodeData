const digits58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

async function hash(bytes) {
    return new Uint8Array(await crypto.subtle.digest('SHA-256', bytes));
}

function toBytes(n, length) {
    const bytes = [];

    for (let i = BigInt(length)-1n; i >= 0; i--) {
        bytes.push((n >> i * 8n) & 0xffn);
    }

    return bytes;
}

function decode_base58(bc, length) {
    let n = 0n;
    for (const char of bc) {
        n = n * 58n + BigInt(digits58.indexOf(char));
    }

    return toBytes(n, length);
}

function toUint8Array(bytes) {
    let nums = []

    for (const byte of bytes) {
        nums.push(Number(byte));
    }

    return new Uint8Array(nums);
}

async function checkBc(bc) {
    const bcbytes = decode_base58(bc, 25);

    const slice = bcbytes.slice(0, bcbytes.length-4);
    const first = toUint8Array(slice);

    const firstHash = await hash(first);
    const secondHash = await hash(firstHash);

    const checksum = toUint8Array(bcbytes.slice(-4));

    return JSON.stringify(checksum) == JSON.stringify(toUint8Array(secondHash.slice(0, 4)));
}

(async () => {
    console.log(await checkBc('1AGNa15ZQXAZUgFiqJ3i7Z2DPU2J6hW62i'));
    console.log(await checkBc("17NdbrSGoUotzeGCcMMCqnFkEvLymoou9j"))
})();
