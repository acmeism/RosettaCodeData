decimals(9)
size = 15
a = list(pow(2,size))
a[1]=1
a[2]=1
power=2
p2=pow(2,power)
peak=0.5
peakpos=0
for n=3 to pow(2,size)
    a[n]=a[a[n-1]]+a[n-a[n-1]]
    r=a[n]/n
    if r>=0.55 mallows=n ok
    if r>peak peak=r peakpos=n ok
    if n=p2
       see "maximum between 2^" + (power - 1) + " and 2^" + power + " is " + peak + " at n=" + peakpos + nl
       power += 1
       p2=pow(2,power)
       peak=0.5 ok
next
see "mallows number is : " + mallows + nl
