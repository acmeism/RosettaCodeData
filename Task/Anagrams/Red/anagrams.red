Red []

m: make map! [] 25000

maxx: 0
foreach word  read/lines http://www.puzzlers.org/pub/wordlists/unixdict.txt [
sword:  sort copy word ;; sorted characters of word

either find m sword [
    append   m/:sword word
    maxx: max maxx length?  m/:sword
   ] [
      put m sword append copy [] word
    ]
]
foreach v values-of m [ if maxx = length? v [print v] ]
