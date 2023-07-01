Public Sub currency_task()
    '4000000000000000 hamburgers at $5.50 each
    Dim number_of_hamburgers As Variant
    number_of_hamburgers = CDec(4E+15)
    Dim price_of_hamburgers As Currency
    price_of_hamburgers = 5.5
    '2 milkshakes at $2.86 each, and
    Dim number_of_milkshakes As Integer
    number_of_milkshakes = 2
    Dim price_of_milkshakes As Currency
    price_of_milkshakes = 2.86
    'a tax rate of 7.65%.
    Dim tax_rate As Single
    tax_rate = 0.0765
    'the total price before tax
    Dim total_price_before_tax As Variant
    total_price_before_tax = number_of_hamburgers * price_of_hamburgers
    total_price_before_tax = total_price_before_tax + number_of_milkshakes * price_of_milkshakes
    Debug.Print "Total price before tax "; Format(total_price_before_tax, "Currency")
    'the tax
    Dim tax As Variant
    tax = total_price_before_tax * tax_rate
    Debug.Print "Tax "; Format(tax, "Currency")
    'the total with tax
    Debug.Print "Total with tax "; Format(total_price_before_tax + tax, "Currency")
End Sub
