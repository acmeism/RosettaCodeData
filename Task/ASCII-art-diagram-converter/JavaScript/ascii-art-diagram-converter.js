// ------------------------------------------------------------[ Boilerplate ]--
const trimWhitespace = s => s.trim();
const isNotEmpty = s => s !== '';
const stringLength = s => s.length;
const hexToBin4 = s => parseInt(s, 16).toString(2).padStart(4, '0');
const concatHexToBin = (binStr, hexStr) => binStr.concat('', hexToBin4(hexStr));
const alignRight = n => s => `${s}`.padStart(n, ' ');
const alignLeft = n => s => `${s}`.padEnd(n, ' ');
const repeatChar = c => n => c.padStart(n, c);
const joinWith = c => arr => arr.join(c);
const joinNl = joinWith('\n');
const joinSp = joinWith(' ');

const printDiagramInfo = map => {
  const pName = alignLeft(8);
  const p5 = alignRight(5);
  const line = repeatChar('-');
  const res = [];
  res.push(joinSp([pName('Name'), p5('Size'), p5('Start'), p5('End')]));
  res.push(joinSp([line(8), line(5), line(5), line(5)]));
  [...map.values()].forEach(({label, bitLength, start, end}) => {
    res.push(joinSp([pName(label), p5(bitLength), p5(start), p5(end)]));
  })
  return res;
}

// -------------------------------------------------------------------[ Main ]--
const parseDiagram = dia => {

  const arr = dia.split('\n').map(trimWhitespace).filter(isNotEmpty);

  const hLine = arr[0];
  const bitTokens = hLine.split('+').map(trimWhitespace).filter(isNotEmpty);
  const bitWidth = bitTokens.length;
  const bitTokenWidth = bitTokens[0].length;

  const fields = arr.filter(e => e !== hLine);
  const allFields = fields.reduce((p, c) => [...p, ...c.split('|')], [])
      .filter(isNotEmpty);

  const lookupMap = Array(bitWidth).fill('').reduce((p, c, i) => {
    const v = i + 1;
    const stringWidth = (v * bitTokenWidth) + (v - 1);
    p.set(stringWidth, v);
    return p;
  }, new Map())

  const fieldMetaMap = allFields.reduce((p, e, i) => {
    const bitLength = lookupMap.get(e.length);
    const label = trimWhitespace(e);
    const start = i ? p.get(i - 1).end + 1 : 0;
    const end = start - 1 + bitLength;
    p.set(i, {label, bitLength, start, end})
    return p;
  }, new Map());

  const pName = alignLeft(8);
  const pBit = alignRight(5);
  const pPat = alignRight(18);
  const line = repeatChar('-');
  const nl = '\n';
  return hexStr => {
    const binString = [...hexStr].reduce(concatHexToBin, '');

    const res = printDiagramInfo(fieldMetaMap);
    res.unshift(joinNl(['Diagram:', ...arr, nl]));
    res.push(joinNl([nl, 'Test string in hex:', hexStr]));
    res.push(joinNl(['Test string in binary:', binString, nl]));
    res.push(joinSp([pName('Name'), pBit('Size'), pPat('Pattern')]));
    res.push(joinSp([line(8), line(5), line(18)]));

    [...fieldMetaMap.values()].forEach(({label, bitLength, start, end}) => {
      res.push(joinSp(
          [pName(label), pBit(bitLength),
            pPat(binString.substr(start, bitLength))]))
    })
    return joinNl(res);
  }
}

// --------------------------------------------------------------[ Run tests ]--

const dia = `
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
`;

const parser = parseDiagram(dia);

parser('78477bbf5496e12e1bf169a4');
