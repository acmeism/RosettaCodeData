def lpd(n):
    for i in range(n-1,0,-1):
        if n%i==0: return i
    return 1

for i in range(1,101):
    print("{:3}".format(lpd(i)), end=i%10==0 and '\n' or '')
