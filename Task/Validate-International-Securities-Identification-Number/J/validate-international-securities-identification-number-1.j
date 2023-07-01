require'regex'
validFmt=: 0 -: '^[A-Z]{2}[A-Z0-9]{9}[0-9]{1}$'&rxindex

df36=: ;@([: <@":"0 '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'&i.)  NB. decimal from base 36
luhn=: 0 = 10 (| +/@,) 10 #.inv 1 2 *&|: _2 "."0\ |.            NB. as per task Luhn_test_of_credit_card_numbers#J

validISIN=: validFmt *. luhn@df36
