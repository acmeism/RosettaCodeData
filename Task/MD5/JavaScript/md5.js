class WBunion {
  constructor() {
    this._w = 0;
    this.b = new Uint8Array(4);
  }

  set w(value) {
    this._w = value >>> 0; // Ensure unsigned 32-bit
    this.b[0] = value & 0xFF;
    this.b[1] = (value >>> 8) & 0xFF;
    this.b[2] = (value >>> 16) & 0xFF;
    this.b[3] = (value >>> 24) & 0xFF;
  }

  get w() {
    return this._w;
  }
}

function f0(abcd) {
  return (abcd[1] & abcd[2]) | (~abcd[1] & abcd[3]);
}

function f1(abcd) {
  return (abcd[3] & abcd[1]) | (~abcd[3] & abcd[2]);
}

function f2(abcd) {
  return abcd[1] ^ abcd[2] ^ abcd[3];
}

function f3(abcd) {
  return abcd[2] ^ (abcd[1] | ~abcd[3]);
}

function calcKs(k) {
  const pwr = Math.pow(2, 32);
  for (let i = 0; i < 64; i++) {
    const s = Math.abs(Math.sin(1 + i));
    k[i] = (s * pwr) >>> 0; // Ensure unsigned 32-bit
  }
  return k;
}

// ROtate v Left by amt bits
function rol(v, amt) {
  const msk1 = (1 << amt) - 1;
  return (((v >>> (32 - amt)) & msk1) | ((v << amt) & ~msk1)) >>> 0; // Ensure unsigned 32-bit
}

function md5(msg) {
  const h0 = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476];
  const ff = [f0, f1, f2, f3];
  const M = [1, 5, 3, 7];
  const O = [0, 1, 5, 0];
  const rot0 = [7, 12, 17, 22];
  const rot1 = [5, 9, 14, 20];
  const rot2 = [4, 11, 16, 23];
  const rot3 = [6, 10, 15, 21];
  const rots = [rot0, rot1, rot2, rot3];
  const kspace = new Array(64);
  let k = calcKs(kspace);

  const h = [...h0]; // Clone h0
  const abcd = new Array(4);

  // Convert string to byte array
  const mlen = msg.length;
  const grps = 1 + Math.floor((mlen + 8) / 64);
  const msg2 = new Uint8Array(64 * grps);

  // Copy message to msg2
  for (let i = 0; i < mlen; i++) {
    msg2[i] = msg.charCodeAt(i) & 0xFF;
  }

  // Append padding bits
  msg2[mlen] = 0x80;

  // Append length (in bits)
  const bitLen = mlen * 8;
  const offset = 64 * grps - 8;
  msg2[offset] = bitLen & 0xFF;
  msg2[offset + 1] = (bitLen >>> 8) & 0xFF;
  msg2[offset + 2] = (bitLen >>> 16) & 0xFF;
  msg2[offset + 3] = (bitLen >>> 24) & 0xFF;

  // Process message in 64-byte chunks
  for (let grp = 0, os = 0; grp < grps; grp++, os += 64) {
    const chunk = msg2.slice(os, os + 64);
    const mm = { w: new Array(16) };

    // Convert bytes to words
    for (let i = 0; i < 16; i++) {
      mm.w[i] = (chunk[i * 4] |
                (chunk[i * 4 + 1] << 8) |
                (chunk[i * 4 + 2] << 16) |
                (chunk[i * 4 + 3] << 24)) >>> 0;
    }

    // Initialize hash values for this chunk
    for (let q = 0; q < 4; q++) {
      abcd[q] = h[q];
    }

    // Main loop
    for (let p = 0; p < 4; p++) {
      const fctn = ff[p];
      const rotn = rots[p];
      const m = M[p];
      const o = O[p];

      for (let q = 0; q < 16; q++) {
        const g = (m * q + o) % 16;
        const f = (abcd[1] + rol(abcd[0] + fctn(abcd) + k[q + 16 * p] + mm.w[g], rotn[q % 4])) >>> 0;

        abcd[0] = abcd[3];
        abcd[3] = abcd[2];
        abcd[2] = abcd[1];
        abcd[1] = f;
      }
    }

    // Add chunk's hash to result
    for (let p = 0; p < 4; p++) {
      h[p] = (h[p] + abcd[p]) >>> 0;
    }
  }

  return h;
}

function main() {
  const msg = "The quick brown fox jumps over the lazy dog.";
  const d = md5(msg);
  let result = "= 0x";

  for (let j = 0; j < 4; j++) {
    const u = new WBunion();
    u.w = d[j];
    for (let k = 0; k < 4; k++) {
      result += u.b[k].toString(16).padStart(2, '0');
    }
  }

  console.log(result);
}

main();
