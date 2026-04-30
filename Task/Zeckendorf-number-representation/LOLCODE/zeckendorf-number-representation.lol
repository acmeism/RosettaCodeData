OBTW print some Zeckendorf number representations

     We handle 32-bit numbers, the maximum fibonacci number that can fit in a
     32 bit number is F(45)
TLDR

HAI 1.3

    BTW PUT 32-BIT FIBONACCI NUMBRS IN A BUKKIT
    I HAS A FIBZ ITZ A BUKKIT
            FIBZ HAS A LENGTH ITZ 45
            FIBZ HAS A SRS 1  ITZ 1
            FIBZ HAS A SRS 2  ITZ 2
    IM IN YR FIBALIZER UPPIN YR N0 TIL BOTH SAEM N0 AN DIFF OF FIBZ'Z LENGTH AN 2 BTW N0 = 0 .. 43
       FIBZ HAS A SRS SUM OF N0 AN 3 ITZ SUM OF FIBZ'Z SRS SUM OF N0 AN 2 ...
                                             AN FIBZ'Z SRS SUM OF N0 AN 1
    IM OUTTA YR FIBALIZER

    BTW FINDS THE ZECKENDORF REPREZENTASHUN OF N OR "?" IF IT CAN'T BE FOUND
    HOW IZ I ZECKENDORFIN YR N AN YR FIBZ
        BOTH SAEM N AN 0, O RLY?
        YA RLY
           FOUND YR "0"
        NO WAI
           I HAS A ZR   ITZ ""
           I HAS A FPOS ITZ FIBZ'Z LENGTH
           I HAS A REST ITZ N
           DIFFRINT 0 AN SMALLR OF N AN 0, O RLY?
           YA RLY
              BTW N IS NEGATIF
              REST R DIFF OF 0 AN N
           OIC

           BTW FIND FIRST NON-ZERO ZECKENDORF DIGT
           IM IN YR FIRSTNZ UPPIN YR WHATEVR ...
                             WILE BOTH OF DIFFRINT FPOS AN SMALLR OF FPOS AN 1 ...
                                       AN DIFFRINT REST AN BIGGR OF REST AN FIBZ'Z SRS FPOS
              FPOS R DIFF OF FPOS AN 1
           IM OUTTA YR FIRSTNZ
           BTW IF WE FOUND A DIGT BUILD THE REPREZENTASHUN
           IM IN YR MOERDIGTZ UPPIN YR WHATEVR WILE DIFFRINT FPOS AN SMALLR OF FPOS AN 0
              DIFFRINT REST AN BIGGR OF REST AN FIBZ'Z SRS FPOS, O RLY?
              YA RLY
                 ZR R SMOOSH ZR AN "0" MKAY
              NO WAI
                 ZR R SMOOSH ZR AN "1" MKAY
                 REST R DIFF OF REST AN FIBZ'Z SRS FPOS
              OIC
              FPOS R DIFF OF FPOS AN 1
           IM OUTTA YR MOERDIGTZ
           BOTH SAEM REST AN 0, O RLY?
           YA RLY
              FOUND YR ZR
           NO WAI
              BTW DIDN'T FIND A REPREZENTASHUN
              FOUND YR "?"
           OIC
        OIC
    IF U SAY SO

    IM IN YR PRINTR UPPIN YR N WILE DIFFRINT N AN 21
       I HAS A PAD ITZ ""
       BOTH SAEM 9 AN BIGGR OF N AN 9, O RLY?
       YA RLY
          PAD R "  "
       MEBBE BOTH SAEM 99 AN BIGGR OF N AN 99
          PAD R " "
       OIC
       VISIBLE PAD N " " I IZ ZECKENDORFIN YR N AN YR FIBZ MKAY
    IM OUTTA YR PRINTR

KTHXBYE
