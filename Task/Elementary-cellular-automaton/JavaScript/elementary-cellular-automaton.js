const alive = '#';
const dead = '.';

// ------------------------------------------------------------[ Bit banging ]--
const setBitAt = (val, idx) => BigInt(val) | (1n << BigInt(idx));
const clearBitAt = (val, idx) => BigInt(val) & ~(1n << BigInt(idx));
const getBitAt = val => idx => (BigInt(val) >> BigInt(idx)) & 1n;
const hasBitAt = val => idx => ((BigInt(val) >> BigInt(idx)) & 1n) === 1n;

// ----------------------------------------------------------------[ Utility ]--
const makeArr = n => Array(n).fill(0);
const reverse = x => Array.from(x).reduce((p, c) => [c, ...p], []);
const numToLine = width => int => {
  const test = hasBitAt(int);
  const looper = makeArr(width);
  return reverse(looper.map((_, i) => test(i) ? alive : dead)).join('');
}

// -------------------------------------------------------------------[ Main ]--
const displayCA = (rule, width, lines, startIndex) => {
  const result = [];
  result.push(`Rule:${rule} Width:${width} Gen:${lines}\n`)
  const ruleTest = hasBitAt(rule);
  const lineLoop = makeArr(lines);
  const looper = makeArr(width);
  const pLine = numToLine(width);

  let nTarget = setBitAt(0n, startIndex);
  result.push(pLine(nTarget));
  lineLoop.forEach(() => {
    const bitTest = getBitAt(nTarget);
    looper.forEach((e, i) => {
      const l = bitTest(i === 0 ? width - 1 : i - 1);
      const m = bitTest(i);
      const r = bitTest(i === width - 1 ? 0 : i + 1);
      nTarget = ruleTest(
          parseInt([l, m, r].join(''), 2))
          ? setBitAt(nTarget, i)
          : clearBitAt(nTarget, i);
    });
    result.push(pLine(nTarget));
  });
  return result.join('\n');
}

displayCA(90, 57, 31, 28);
