Say "enter first dimension"
pull d1
say "enter the second dimension"
pull d2
a = .array~new(d1, d2)
a[1, 1] = "Abc"
say a[1, 1]
say d1 d2 a[d1,d2]
say a[10,10]
max=1000000000
b = .array~new(max,max)
