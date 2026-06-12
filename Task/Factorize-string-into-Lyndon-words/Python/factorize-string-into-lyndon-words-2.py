m='0'
for i in range(0,7):
     m0=m
     m=m.replace('0','a')
     m=m.replace('1','0')
     m=m.replace('a','1')
     m=m0+m

print(chen_fox_lyndon_factorization(m))
