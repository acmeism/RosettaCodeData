const key = "]kYV}(!7P$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ";

function encode(s) {
  let result = '';

  for (let i = 0; i < s.length; i++) {
    result += key[s.charCodeAt(i) - 32];
  }

  return result;
}

function decode(s) {
  let result = '';

  for (let i = 0; i < s.length; i++) {
    result += String.fromCharCode(key.indexOf(s[i]) + 32);
  }

  return result;
}

function main() {
  const s = "The quick brown fox jumps over the lazy dog, who barks VERY loudly!";
  const enc = encode(s);
  console.log("Encoded: ", enc);
  console.log("Decoded: ", decode(enc));
}

main();
