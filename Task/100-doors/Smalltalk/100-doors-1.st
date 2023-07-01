|a|
a := Array new: 100 .
1 to: 100 do: [ :i | a at: i put: false ].

1 to: 100 do: [ :pass |
  pass to: 100 by: pass do: [ :door |
    a at: door put: (a at: door) not .
  ]
].

"output"
1 to: 100 do: [ :door |
   ( 'door #%1 is %2' %
     { door . (a at: door) ifTrue: [ 'open' ] ifFalse: [ 'closed' ] } ) displayNl
]
