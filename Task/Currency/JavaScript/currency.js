const money = require('money-math')

let hamburgers = 4000000000000000
let hamburgerPrice = 5.50

let shakes = 2
let shakePrice = 2.86

let tax = 7.65

let hamburgerTotal = money.mul(hamburgers.toFixed(0), money.floatToAmount(hamburgerPrice))
let shakeTotal = money.mul(shakes.toFixed(0), money.floatToAmount(shakePrice))

let subTotal = money.add(hamburgerTotal, shakeTotal)

let taxTotal = money.percent(subTotal, tax)

let total = money.add(subTotal, taxTotal)

console.log('Hamburger Total:', hamburgerTotal)
console.log('Shake Total:', shakeTotal)
console.log('Sub Total:', subTotal)
console.log('Tax:', taxTotal)
console.log('Total:', total)
