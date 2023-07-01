USING: combinators.smart io kernel math math.functions money ;

10 15 ^ 4 * 5+50/100 * ! hamburger subtotal
2 2+86/100 *           ! milkshake subtotal
+                      ! subtotal
dup DECIMAL: 0.0765 *  ! tax
[ + ] preserving       ! total

"Total before tax: " write [ money. ] 2dip
"Tax: " write [ money. ] dip
"Total with tax: " write money.
