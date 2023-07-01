# Project  : Currency

nhamburger  = "4000000000"
phamburger  = "5.50"
nmilkshakes = "2"
pmilkshakes = "2.86"
taxrate = "0.0765"
price = nhamburger * phamburger + nmilkshakes * pmilkshakes
tax = price * taxrate
see "total price before tax : " + price + nl
see "tax thereon @ 7.65 : " + tax + nl
see "total price after tax  : " + (price + tax) + nl
