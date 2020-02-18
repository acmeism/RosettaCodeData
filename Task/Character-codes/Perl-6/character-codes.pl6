for 'AΑА𪚥🇺🇸👨‍👩‍👧‍👦'.comb {
    .put for
    [ 'Character',
      'Character name',
      'Unicode property',
      'Ordinal(s)',
      'Hex ordinal(s)',
      'UTF-8',
      'UTF-16LE',
      'UTF-16BE',
      'Round trip by name',
      'Round trip by ordinal'
    ]».fmt('%21s:')
    Z
    [ $_,
      .uninames.join(', '),
      .uniprops,
      .ords,
      .ords.fmt('0x%X'),
      .encode('utf8'   )».fmt('%02X'),
      .encode('utf16le')».fmt('%02X').join.comb(4),
      .encode('utf16be')».fmt('%02X').join.comb(4),
      .uninames».uniparse.join,
      .ords.chrs
    ];
    say '';
}
