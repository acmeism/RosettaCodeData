#TXT$ = "On the * day of Christmas, my true love sent to me:"
days$ = ~"first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth\nninth\ntenth\neleventh\ntwelfth\n"
gifts$= ~"Twelve drummers drumming,\nEleven pipers piping,\nTen lords a-leaping,\nNine ladies dancing,\n"+
        ~"Eight maids a-milking,\nSeven swans a-swimming,\nSix geese a-laying,\nFive golden rings,\n"+
        ~"Four calling birds,\nThree french hens,\nTwo turtle doves,\nA partridge in a pear tree.\n"
Define  I.i, J.i

If OpenConsole("The twelve days of Christmas")
  For I = 1 To 12
    PrintN(ReplaceString(#TXT$,"*",StringField(days$,I,~"\n")))
    For J = 13-I To 12
      PrintN(" -> "+StringField(gifts$,J,~"\n"))
    Next J
  Next I
  Input()
EndIf
