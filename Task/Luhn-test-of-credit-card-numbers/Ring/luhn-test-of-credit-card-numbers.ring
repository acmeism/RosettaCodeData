cardnumber = [49927398716, 49927398717]
decimals(0)

for cards = 1 to len(cardnumber)
    if luhn(cardnumber[cards])
       see "card number " + cardnumber[cards] + " is valid" + nl
    else see "card number " + cardnumber[cards] + " is invalid" + nl ok
next

func luhn card
     s = 0
     ln = len(string(card))
     for i = 1 to ln
         n = number(substr(string(card), ln-i+1, 1))
         if (i & 1) s += n + nl
         else n *= 2
         s += (n % 10) + floor(n/ 10) ok
     next
     return (s % 10) = 0
