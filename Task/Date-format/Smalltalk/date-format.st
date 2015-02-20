| d |
d := Date today.
d printFormat: #(3 2 1 $- 1 1 2).
(d weekday asString), ', ', (d monthName), ' ', (d dayOfMonth asString), ', ', (d year asString)
