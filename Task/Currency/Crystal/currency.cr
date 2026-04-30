require "big"

def f (n, d=2); n.format(decimal_places: d) end

check = <<-EOC.lines.map(&.split).map {|(desc, price, qty)| { desc, price.to_big_d, qty.to_big_d } }
  Hamburger  5.50  4000000000000000
  Milkshake  2.86                 2
  EOC

tax_rate = 0.0765

fmt = "%-10s %8s %23s %27s\n"

printf fmt, %w(Item Price Quantity Amount)

subtotal = check.sum {|item, price, quant|
  amount = price * quant
  printf fmt, item, f(price), f(quant, 0), f(amount.round(2))
  amount
}
printf fmt, "", "", "", "-------------------------"
printf fmt, "", "", "Subtotal ", f(subtotal)

tax = (subtotal * tax_rate).round(2)
printf fmt, "", "", "Tax ", f(tax)

total = subtotal + tax
printf fmt, "", "", "Total ", f(total)
