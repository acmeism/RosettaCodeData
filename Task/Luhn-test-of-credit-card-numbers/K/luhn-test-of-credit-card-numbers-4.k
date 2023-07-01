luhn:{[cc]
    digits:0$/:|cc / convert chars to digit ints
    s:digits*(#cc)#1 2 / evens doubled, odds not
    nines:+/s>9 / number of sums greater than 9
    :~((+/s)-(9*nines))!10 / sum minus the nines is mod ten?
    }
