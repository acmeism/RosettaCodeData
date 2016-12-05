strReversed = '---------- Ice and Fire ------------\n\n
fire, in end will world the say Some\n
ice. in say Some\n
desire of tasted I\'ve what From\n
fire. favor who those with hold I\n\n
... elided paragraph last ...\n\n
Frost Robert -----------------------'

reverseString = (s) ->
  s.split('\n').map((l) -> l.split(/\s/).reverse().join ' ').join '\n'

console.log reverseString(strReversed)
