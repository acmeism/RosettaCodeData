using Printf

p  = [big"5.50", big"2.86"]
q  = [4000000000000000, 2]
tr = big"0.0765"

beftax = p' * q
tax    = beftax * tr
afttax = beftax + tax

@printf " - tot. before tax: %20.2f \$\n" beftax
@printf " -             tax: %20.2f \$\n" tax
@printf " - tot. after  tax: %20.2f \$\n" afttax
