HAI 1.2

HOW IZ I FurstDigit YR Numbr
  I HAS A Digit
  IM IN YR Loop NERFIN YR Dummy WILE DIFFRINT Numbr AN 0
    Digit R MOD OF Numbr AN 10
    Numbr R QUOSHUNT OF Numbr AN 10
  IM OUTTA YR Loop
  FOUND YR Digit
IF U SAY SO

HOW IZ I LastDigit YR Numbr
  FOUND YR MOD OF Numbr AN 10
IF U SAY SO

HOW IZ I Bookend YR Numbr
  FOUND YR SUM OF PRODUKT OF I IZ FurstDigit YR Numbr MKAY AN 10 AN I IZ LastDigit YR Numbr MKAY
IF U SAY SO

HOW IZ I CheckGapful YR Numbr
  I HAS A Bookend ITZ I IZ Bookend YR Numbr MKAY
  I HAS A BigEnuff ITZ BOTH SAEM Numbr AN BIGGR OF Numbr AN 100
  FOUND YR BOTH OF BigEnuff AN BOTH SAEM 0 AN MOD OF Numbr AN Bookend
IF U SAY SO

HOW IZ I FindGapfuls YR Start AN YR HowMany
  I HAS A Numbr ITZ Start
  I HAS A Anser ITZ A BUKKIT
  I HAS A Found ITZ 0
  IM IN YR Loop UPPIN YR Dummy WILE DIFFRINT Found AN HowMany
    I IZ CheckGapful YR Numbr MKAY
    O RLY?
      YA RLY
        Anser HAS A SRS Found ITZ Numbr
        Found R SUM OF Found AN 1
    OIC
    Numbr R SUM OF Numbr AN 1
  IM OUTTA YR Loop
  FOUND YR Anser
IF U SAY SO

HOW IZ I Report YR Start AN YR HowMany
  VISIBLE "The furst " !
  VISIBLE HowMany !
  VISIBLE " Gapful numbrs starting with " !
  VISIBLE Start !
  VISIBLE "::"
  I HAS A Anser ITZ I IZ FindGapfuls YR Start AN YR HowMany MKAY
  IM IN YR Loop UPPIN YR Index TIL BOTH SAEM Index AN HowMany
    DIFFRINT Index AN 0
    O RLY?
      YA RLY
        VISIBLE ", " !
    OIC
    VISIBLE Anser'Z SRS Index !
  IM OUTTA YR Loop
  VISIBLE ""
  VISIBLE ""
IF U SAY SO

I IZ Report YR 1 AN YR 30 MKAY
I IZ Report YR 1000000 AN YR 15 MKAY
I IZ Report YR 1000000000 AN YR 10 MKAY
KTHXBYE
