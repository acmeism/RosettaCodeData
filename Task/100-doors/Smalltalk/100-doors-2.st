|a|
a := (1 to: 100) collect: [ :x | false ].
1 to: 10 do: [ :i | a at: (i squared) put: true ].
1 to: 100 do: [ :i |
   ( 'door #%1 is %2' % { i .
           (a at: i) ifTrue: [ 'open' ]
                     ifFalse: [ 'closed' ] }
   ) displayNl
]
