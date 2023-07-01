decimals(8)
y = 1.0
for i = 0 to 100
    t = i  / 10
    if t = floor(t)
       actual = (pow((pow(t,2) + 4),2)) / 16
       see "y(" + t + ") = " + y + "  error = " + (actual - y) + nl ok
    k1 =  t * sqrt(y)
    k2 = (t + 0.05) * sqrt(y + 0.05 * k1)
    k3 = (t + 0.05) * sqrt(y + 0.05 * k2)
    k4 = (t + 0.10) * sqrt(y + 0.10 * k3)
    y += 0.1 * (k1 + 2 * (k2 + k3) + k4) / 6
next
