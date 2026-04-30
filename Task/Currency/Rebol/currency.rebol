Rebol [
    title: "Rosetta code: Currency"
    file:  %Currency.r3
    url:   https://rosettacode.org/wiki/Currency
    needs: 3.0.0
]

hamburgers:      4'000'000'000'000'000
hamburger-price: $5.50
milkshakes:      2
milkshake-price: $2.86
tax-rate:        7.65%

total-price: (hamburgers * hamburger-price) + (milkshakes * milkshake-price)
tax:   total-price * tax-rate
total: total-price + tax

print ["Total price before tax :" round/to total-price $0.01]
print ["Tax                    :" round/to tax         $0.01]
print ["Total price after tax  :" round/to total       $0.01]
