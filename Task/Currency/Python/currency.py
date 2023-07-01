from decimal import Decimal as D
from collections import namedtuple

Item = namedtuple('Item', 'price, quant')

items = dict( hamburger=Item(D('5.50'), D('4000000000000000')),
              milkshake=Item(D('2.86'), D('2')) )
tax_rate = D('0.0765')

fmt = "%-10s %8s %18s %22s"
print(fmt % tuple('Item Price Quantity Extension'.upper().split()))

total_before_tax = 0
for item, (price, quant) in sorted(items.items()):
    ext = price * quant
    print(fmt % (item, price, quant, ext))
    total_before_tax += ext
print(fmt % ('', '', '', '--------------------'))
print(fmt % ('', '', 'subtotal', total_before_tax))

tax = (tax_rate * total_before_tax).quantize(D('0.00'))
print(fmt % ('', '', 'Tax', tax))

total = total_before_tax + tax
print(fmt % ('', '', '', '--------------------'))
print(fmt % ('', '', 'Total', total))
