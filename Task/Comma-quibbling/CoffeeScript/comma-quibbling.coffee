quibble = ([most..., last]) ->
  '{' +
    (most.join ', ') +
    (if most.length then ' and ' else '')  +
    (last or '') +
  '}'

console.log quibble(s) for s in [ [], ["ABC"], ["ABC", "DEF"],
                                  ["ABC", "DEF", "G", "H" ]   ]
