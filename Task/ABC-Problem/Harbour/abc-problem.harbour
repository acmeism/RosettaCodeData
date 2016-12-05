PROCEDURE Main()

   LOCAL cStr

   FOR EACH cStr IN { "A", "BARK", "BooK", "TrEaT", "comMON", "sQuAd", "Confuse" }
      ? PadL( cStr, 10 ), iif( Blockable( cStr ), "can", "cannot" ), "be spelled with blocks."
   NEXT

   RETURN

STATIC FUNCTION Blockable( cStr )

   LOCAL blocks := { ;
      "BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS", ;
      "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM" }

   LOCAL cFinal := ""
   LOCAL i, j

   cStr := Upper( cStr )

   FOR i := 1 TO Len( cStr )
      FOR EACH j IN blocks
         IF SubStr( cStr, i, 1 ) $ j
            cFinal += SubStr( cStr, i, 1 )
            j := ""
            EXIT
         ENDIF
      NEXT
   NEXT

   RETURN cFinal == cStr
