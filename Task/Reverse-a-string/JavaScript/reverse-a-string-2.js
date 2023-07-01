a = "\u{1F466}\u{1F3FB}\u{1f44b}"; // '👦🏻👋'

// wrong behavior - ASCII sequences
a.split('').reverse().join(''); // '\udc4b🁦\ud83d'

// wrong behavior - Unicode code points
[...a].reverse().join(''); // '👋🏻👦'
a.split(/(?:)/u).reverse().join(''); // '👋🏻👦'

// correct behavior - Unicode graphemes
[...new Intl.Segmenter().segment(a)].map(x => x.segment).reverse().join('') // 👋👦🏻
