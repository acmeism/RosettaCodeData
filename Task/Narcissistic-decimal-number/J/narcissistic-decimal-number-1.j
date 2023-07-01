getDigits=: "."0@":                  NB. get digits from number
isNarc=: (= +/@(] ^ #)@getDigits)"0  NB. test numbers for Narcissism
