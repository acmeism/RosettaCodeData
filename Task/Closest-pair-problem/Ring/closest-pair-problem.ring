decimals(10)
x = list(10)
y = list(10)
x[1] = 0.654682
y[1] = 0.925557
x[2] = 0.409382
y[2] = 0.619391
x[3] = 0.891663
y[3] = 0.888594
x[4] = 0.716629
y[4] = 0.996200
x[5] = 0.477721
y[5] = 0.946355
x[6] = 0.925092
y[6] = 0.818220
x[7] = 0.624291
y[7] = 0.142924
x[8] = 0.211332
y[8] = 0.221507
x[9] = 0.293786
y[9] = 0.691701
x[10] = 0.839186
y[10] = 0.728260

min = 10000
for i = 1 to 9
    for j = i+1 to 10
        dsq = pow((x[i] - x[j]),2) + pow((y[i] - y[j]),2)
        if dsq < min min = dsq  mini = i minj = j ok
    next
next
see "closest pair is : " + mini + " and " + minj + " at distance " + sqrt(min)
