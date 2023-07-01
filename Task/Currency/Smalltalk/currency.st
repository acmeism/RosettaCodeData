check := #(
    " amount         name           price  "
    (4000000000000000 'hamburger'    5.50s2 )
    (2                'milkshakes'   2.86s2 )
).
tax := 7.65s2.
fmt := '%-10s %10P %22P %26P\n'.

totalSum := 0.
totalTax := 0.

Transcript clear.
Transcript printf:fmt withAll:#('Item' 'Price' 'Qty' 'Extension').
Transcript printCR:('-' ,* 72).

check do:[:entry|
    |amount name price itemTotal itemTax|

    amount := entry[1].
    name   := entry[2].
    price  := entry[3].
    itemTotal := (price*amount).
    itemTax   := ((price*amount)*tax/100) roundedToScale.

    totalSum := totalSum + itemTotal.
    totalTax := totalTax + itemTax.
    Transcript printf:fmt
               withAll:{name . price . amount . itemTotal}.
].
Transcript printCR:('-' ,* 72).
Transcript printf:fmt withAll:{'' . '' . 'Subtotal' . totalSum}.
Transcript printf:fmt withAll:{'' . '' . 'Tax' . totalTax}.
Transcript printf:fmt withAll:{'' . '' . 'Total' . (totalSum+totalTax)}.

Transcript cr; printCR:('Enjoy your Meal & Thank You for Dining at Milliways')
