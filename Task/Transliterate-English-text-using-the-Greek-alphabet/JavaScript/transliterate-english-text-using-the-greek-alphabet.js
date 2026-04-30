const regexps = {"\u0391": /A/g,
                 "\u0392": /[BV]/g,
                 "\u0393": /G/g,
                 "\u0394": /D/g,
                 "\u0395": /E(?!e)/g,
                 "\u0396": /Z/g,
                 "\u0397": /H|Ee/g,
                 "\u0398": /Th/g,
                 "\u0399": /[IJ]/g,
                 "\u039A": /(C|K)(?!h)|Q/g,
                 "\u039B": /L/g,
                 "\u039C": /M/g,
                 "\u039D": /N/g,
                 "\u039E": /X/g,
                 "\u039F": /O(?!o)/g,
                 "\u03A0": /P(?![hs])/g,
                 "\u03A1": /Rh|R/g,
                 "\u03A3": /S/g,
                 "\u03A4": /T(?!h)/g,
                 "\u03A5": /[UY]/g,
                 "\u03A6": /F|Ph/g,
                 "\u03A7": /(C|K)h/g,
                 "\u03A8": /Ps/g,
                 "\u03A9": /W|Oo/g,
                 "\u03B1": /a/g,
                 "\u03B2": /[bv]/g,
                 "\u03B3": /g/g,
                 "\u03B4": /d/g,
                 "\u03B5": /(?<!e)e(?!e)/g,
                 "\u03B6": /z/g,
                 "\u03B7": /(?<![ckprt])h|ee/g,
                 "\u03B8": /th/g,
                 "\u03B9": /[ij]/g,
                 "\u03BA": /(ck|c|k)(?!h)|q/g,
                 "\u03BB": /l/g,
                 "\u03BC": /m/g,
                 "\u03BD": /n/g,
                 "\u03BE": /x/g,
                 "\u03BF": /(?<!o)o(?!o)/g,
                 "\u03C0": /p(?![hs])/g,
                 "\u03C1": /rh|r/g,
                 "\u03C2": /(?<!p)s(?=[\s\.,:;!?])/g,
                 "\u03C3": /(?<!p)s/g,
                 "\u03C4": /t(?!h)/g,
                 "\u03C5": /[uy]/g,
                 "\u03C6": /f|ph/g,
                 "\u03C7": /(c|k)h/g,
                 "\u03C8": /ps/g,
                 "\u03C9": /w|oo/g};

function eng2greek(s) {
  for (const letter in regexps) {
    s = s.replaceAll(regexps[letter], letter);
  }
  return s;
}

const text1 = "The quick brown fox jumped over the lazy dog.";
const text2 = "sphinx of black quartz, judge my vow.";
const longtext = "I was looking at some rhododendrons in my back garden, "+
                 "dressed in my khaki shorts, when the telephone rang. "+
                 "As I answered it, I cheerfully glimpsed that the July sun "+
                 "caused a fragment of black pine wax to ooze on the velvet "+
                 "quilt laying in my patio.";

console.log(eng2greek(text1));
console.log(eng2greek(text2));
console.log(eng2greek(longtext));
