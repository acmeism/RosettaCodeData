dict keysAndValuesDo:[:eachOption :eachValue |
   someObject
       perform:(eachOption,':') asSymbol with:eachValue
       ifNotUnderstood: [ self error: 'unknown option: ', eachOption ]
]
