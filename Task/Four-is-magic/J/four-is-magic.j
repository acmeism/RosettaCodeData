names =. 'one';'two';'three';'four';'five';'six';'seven';'eight';'nine';'ten';'eleven';'twelve';'thirteen';'fourteen';'fifteen';'sixteen';'seventeen';'eighteen';'nineteen'

tens =. '';'twenty';'thirty';'forty';'fifty';'sixty';'seventy';'eighty';'ninety'

NB. selects the xth element from list y
lookup =: >@{:@{.

NB. string formatting
addspace =: ((' '"_, ]) ` ]) @. (<&0 @ {: @ $)

NB. numbers in range 1 to 19
s1 =: lookup&names

NB. numbers in range 20 to 99
s2d=: (lookup&tens @ <. @ %&10) , addspace @ (s1 @ (10&|))

NB. numbers in range 100 to 999
s3d =: s1 @ (<.@%&100), ' hundred', addspace @ s2d @ (100&|)

NB. numbers in range 1 to 999
s123d =: s1 ` s2d ` s3d @. (>& 19 + >&99)

NB. numbers in range 1000 to 999999
s456d =: (s123d @<.@%&1000), ' thousand', addspace @ s123d @ (1000&|)

NB. stringify numbers in range 1 to 999999
stringify =: s123d ` s456d @. (>&999)

NB. takes an int and returns an int of the length of the string of the input
lengthify =: {: @ $ @ stringify

NB. determines the string that should go after ' is '
what =: ((stringify @ lengthify), (', '"_)) ` ('magic'"_) @. (=&4)

runonce =: stringify , ' is ', what

run =: runonce, ((run @ lengthify) ` (''"_) @. (=&4))

doall =: run"0

inputs =: 4 8 16 25 89 365 2586 25865 369854

doall inputs
