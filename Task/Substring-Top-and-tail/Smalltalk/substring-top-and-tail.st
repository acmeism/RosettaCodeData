s := 'upraisers'.
Transcript show: 'Top: ', s allButLast; nl.
Transcript show: 'Tail: ', s allButFirst; nl.
Transcript show: 'Without both: ', s allButFirst allButLast; nl.
Transcript show: 'Without both using substring method: ', (s copyFrom: 2 to: s size - 1); nl.
