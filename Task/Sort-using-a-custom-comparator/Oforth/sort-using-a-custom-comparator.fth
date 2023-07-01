String method: customCmp(s)
   s size self size > ifTrue: [ true return ]
   s size self size < ifTrue: [ false return ]
   s toUpper self toUpper <= ;

["this", "is", "a", "set", "of", "strings", "to", "sort", "This", "Is", "A", "Set", "Of", "Strings", "To", "Sort"]
sortWith(#customCmp) println
